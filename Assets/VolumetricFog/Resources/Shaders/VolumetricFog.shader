Shader "VolumetricFogAndMist/VolumetricFog" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NoiseTex ("Noise (RGB)", 2D) = "white" {}
		_FogDensity ("Density", Range (0, 1)) = 1
		_FogAlpha ("Alpha", Range (0, 1)) = 1
		_FogDistance ("Distance", Range (0, 1000)) = 0
		_FogDistanceFallOff ("Distance Start FallOff", Range (0, 1)) = 1
		_MaxFogLength ("Max Fog Length", Range (0, 1000)) = 0
		_FogHeight ("Height", Range (0, 100)) = 1
		_FogBaseHeight("Baseline Height", float) = 0
		_FogScale ("Scale", Range (1, 10)) = 1
		_Color ("Fog Color", Color) = (0.9,0.9,0.9)
		_FogSpecularColor ("Fog Specular Color", Color) = (1,1,0.8)
		_FogSkyHaze ("Sky Haze", Range (0, 500)) = 50
		_FogSkySpeed ("Sky Speed", Range (0, 1)) = 0.3
		_FogSkyNoise ("Sky Noise", Range (0, 1)) = 0
		_FogSkyAlpha ("Sky Alpha", Range (0, 1)) = 0.8
		_FogLightColor ("Light Color", Color) = (1,1,1)
		_FogLightIntensity ("Light Intensity", Range(0, 1)) = 0.2
		_FogSpecular ("Fog Specular", float) = 0.2
		_FogWindDir ("Wind Direction", Vector) = (1,0,0)	
		_FogStepping ("Fog Stepping", float) = 12
		_FogSteppingNear ("Fog Stepping", float) = 1
		_FogVoidPosition("Fog Void Position", Vector) = (0,0,0)
		_FogVoidFallOff("Fog Void FallOff", float) = 1
		_FogVoidRadius("Fog Void Radius", float) = 0
		_FogVoidHeight("Fog Void Height", float) = 0
		_FogVoidDepth("Fog Void Depth", float) = 0
		_FogOfWarCenter("Fog Of War Center", Vector) = (0,0,0)
		_FogOfWarSize("Fog Of War Size", Vector) = (1,1,1)
		_FogOfWar ("Fog of War Mask", 2D) = "white" {}
	}
        	
	CGINCLUDE
	#pragma fragmentoption ARB_precision_hint_fastest
	#pragma multi_compile __ FOG_DISTANCE_ON
	#pragma multi_compile __ FOG_VOID_ON FOG_BOX_VOID_ON
	#pragma multi_compile __ FOG_HAZE_ON
	#pragma multi_compile __ FOG_OF_WAR_ON
	
	#pragma target 3.0
	#include "UnityCG.cginc"
	
	sampler2D _MainTex;
	sampler2D _NoiseTex;
	sampler2D_float _CameraDepthTexture;
	sampler2D_float _DepthTexture;
	sampler2D _FogDownsampled;
	float4 _MainTex_TexelSize;
    float4x4 _ClipToWorld;

	float _FogDensity;
	fixed _FogAlpha;
	float _FogDistance;
	float _FogDistanceFallOff;
	float _MaxFogLength;
	float _FogHeight, _FogBaseHeight;
	float _FogQuality;
	fixed3 _Color;
	float3 _FogWindDir;
	float _FogLightIntensity;
	fixed3 _FogLightColor, _FogSpecularColor;
	float _FogSpecular;
	float _FogStepping, _FogSteppingNear;
	float _FogScale;
	float3 _FogVoidPosition;
	float _FogVoidIntensity, _FogVoidRadius, _FogVoidHeight, _FogVoidDepth, _FogVoidFallOff;

	float _FogSkySpeed;
	#if FOG_HAZE_ON	
	float _FogSkyHaze;
	float _FogSkyNoise;
	float _FogSkyAlpha;
	#endif
	
    #if FOG_OF_WAR_ON 
    sampler2D _FogOfWar;
    float3 _FogOfWarCenter;
    float3 _FogOfWarSize;
    float3 _FogOfWarCenterAdjusted;
    #endif
    
    const fixed4 zeros = fixed4(0,0,0,0);
    
    struct appdata {
    	float4 vertex : POSITION;
		half2 texcoord : TEXCOORD0;
    };
    
	struct v2f {
	    float4 pos : POSITION;
	    float2 uv: TEXCOORD0;
    	float2 depthUV : TEXCOORD1;
    	float3 cameraToFarPlane : TEXCOORD2;
	};

	v2f vert(appdata v) {
    	v2f o;
    	o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
    	o.depthUV = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);
   		o.uv = o.depthUV;
   	      
    	#if UNITY_UV_STARTS_AT_TOP
    	if (_MainTex_TexelSize.y < 0) {
	        // Depth texture is inverted WRT the main texture
    	    o.depthUV.y = 1 - o.depthUV.y;
    	}
    	#endif
               
    	// Clip space X and Y coords
    	float2 clipXY = o.pos.xy / o.pos.w;
               
    	// Position of the far plane in clip space
    	float4 farPlaneClip = float4(clipXY, 1, 1);
               
    	// Homogeneous world position on the far plane
    	farPlaneClip *= float4(1,_ProjectionParams.x,1,1);	
    	float4 farPlaneWorld4 = mul(_ClipToWorld, farPlaneClip);
               
    	// World position on the far plane
    	float3 farPlaneWorld = farPlaneWorld4.xyz / farPlaneWorld4.w;
               
    	// Vector from the camera to the far plane
    	o.cameraToFarPlane = farPlaneWorld - _WorldSpaceCameraPos;
    	
    	return o;
	}


	float3 getWorldPos(v2f i, float depth01) {
    	// Reconstruct the world position of the pixel
     	_WorldSpaceCameraPos.y -= _FogBaseHeight;
    	float3 worldPos = (i.cameraToFarPlane * depth01) + _WorldSpaceCameraPos;
    	return worldPos;
    }

	#if FOG_HAZE_ON
	fixed4 getSkyColor(fixed4 color, float3 worldPos) {
		// Compute sky color
		float y = max(worldPos.y + _FogBaseHeight,1);
		float2 np = float2(worldPos.x/y, worldPos.z/y);
		float skyNoise = tex2D(_NoiseTex, np*_FogScale +_Time[0]*_FogSkySpeed).g;
		float t = _FogSkyAlpha * saturate((_FogSkyHaze/y)*(1.0-skyNoise*_FogSkyNoise));
		color.rgb = lerp(color.rgb, _FogLightIntensity*_Color, t);
		return color;
	}
	#endif

	fixed4 fogColor(float3 worldPos, float depth01) {
		
		// early exit if fog is not crossed
		if (_WorldSpaceCameraPos.y>_FogHeight && worldPos.y>_FogHeight) {
			return zeros;		
		}
		if (_WorldSpaceCameraPos.y<-_FogHeight && worldPos.y<-_FogHeight) {
			return zeros;		
		}
 		
 		#if FOG_VOID_ON	|| FOG_BOX_VOID_ON || FOG_OF_WAR_ON || FOG_DISTANCE_ON
 		fixed voidAlpha = 1.0f;
 		#endif
 		
 		#if FOG_VOID_ON
		if (depth01<0.999) {
			float voidDistance = distance(_FogVoidPosition, worldPos) / _FogVoidRadius;
			voidAlpha = saturate(lerp(1, voidDistance, _FogVoidFallOff));
			if (voidAlpha<=0) return zeros;
		}
		#elif FOG_BOX_VOID_ON
		if (depth01<0.999) {
			float3 absPos = abs(_FogVoidPosition - worldPos);
			float voidDistanceX = absPos.x / _FogVoidRadius;
			float voidDistanceY = absPos.y / _FogVoidHeight;
			float voidDistanceZ = absPos.z / _FogVoidDepth;
			float voidDistance = max(max(voidDistanceX, voidDistanceY), voidDistanceZ);
			voidAlpha = saturate(lerp(1, voidDistance, _FogVoidFallOff));
			if (voidAlpha <=0) return zeros;
		}
		#endif
		
		#if FOG_OF_WAR_ON
		if (depth01<0.999) {
			float2 fogTexCoord = worldPos.xz / _FogOfWarSize.xz - _FogOfWarCenterAdjusted.xz;
			voidAlpha = tex2D(_FogOfWar, fogTexCoord).a;
			if (voidAlpha <=0) return zeros;
		}
		#endif
		
		// Determine "fog length" and initial ray position between object and camera, cutting by fog distance params
		float3 adir = worldPos - _WorldSpaceCameraPos;
		float delta = length(adir.xz) / adir.y;
		
		// ceiling cut
		#if FOG_DISTANCE_ON
		float maxh =  (_FogDistance  * (1.0 - _FogDistanceFallOff)) / delta;
		float h = clamp(_WorldSpaceCameraPos.y + maxh, -_FogHeight, _FogHeight);
		#else
		float h = clamp(_WorldSpaceCameraPos.y, -_FogHeight, _FogHeight);
		#endif
		
		float xh = delta * (_WorldSpaceCameraPos.y - h);
		float2 ndirxz = normalize(adir.xz);
		float2 xz = _WorldSpaceCameraPos.xz - ndirxz * xh;
		float3 fogCeilingCut = float3(xz.x, h, xz.y);
		
		// does fog stars after pixel? If it does, exit now
		float dist  = min(length(adir), _MaxFogLength);
		float distanceToFog = distance(fogCeilingCut, _WorldSpaceCameraPos);
		if (distanceToFog>=dist) return zeros;
		
		// floor cut
		float hf = 0;
		// edge cases
		if (delta>0 && worldPos.y > -0.5) {
			hf = _FogHeight;
		} else if (delta<0 && worldPos.y < 0.5) {
			hf = - _FogHeight;
		}
		
		float xf = delta * ( hf - _WorldSpaceCameraPos.y ); 
		
		// apply start distance fall off
		#if FOG_DISTANCE_ON
		float axf = _FogDistance - abs(delta * (sign(_WorldSpaceCameraPos.y) * _FogHeight + _WorldSpaceCameraPos.y));
		if (axf>0) {
			voidAlpha = saturate(1 - axf / (_FogDistance * _FogDistanceFallOff));
			if (voidAlpha<=0) return zeros;
 		}
 		#endif
 		
		float2 xzb = _WorldSpaceCameraPos.xz - ndirxz * xf;
		float3 fogFloorCut = float3(xzb.x, hf, xzb.y);

		// fog length is...
		float fogLength = distance(fogCeilingCut, fogFloorCut);
		fogLength = min(fogLength, dist - distanceToFog);
		if (fogLength<=0) return zeros;
		
		// Calc Ray-march params
		float3 dir  = normalize(adir);		// ray direction
		float r = 0.1 + max( log(fogLength),0 )/_FogStepping;		// stepping ratio with atten detail with distance
		r *= saturate (dist * _FogSteppingNear);
		r = max(r, 0.01);

		// Extracted operations from ray-march loop for additional optimizations
		dir *= r;
		dir.y /= _FogHeight;
		dir.xz *= _FogScale;
		float4 ft4 = float4(fogCeilingCut.xyz, 0); 
		float2 disp = _Time[1] * _FogWindDir.xz;  // apply wind speed and direction; already defined above if the condition is true
		ft4.xz += disp / _FogScale;
		ft4.xz *= _FogScale;
		ft4.y /= _FogHeight;				
		// allow fog to be elevated from ground
		dir.y *= sign(ft4.y);
		ft4.y = abs(ft4.y);
		
		// Ray-march
		fixed4 sum = zeros;
		fixed den;
		for (fogLength=fogLength;fogLength>0;fogLength-=r, ft4.xyz+=dir) {	// forced self init due to a weird compiler bug
			fixed4 ng = tex2Dlod(_NoiseTex, ft4.xzww);
			den = ng.g - ft4.y;
			if (den > 0) {
				den *= _FogDensity;
				fixed4 fgCol = fixed4(_Color * (1.0-den), den * 0.4);
				fixed3 fgLight = _FogLightColor + _FogSpecularColor * ng.rrr;
				fgCol.rgb *= fgLight * fgCol.aaa;
				sum += fgCol * (1.0-sum.a);
				if (sum.a>0.99) break;
			} 	
		}
		sum *= _FogAlpha;

		#if FOG_VOID_ON	|| FOG_BOX_VOID_ON || FOG_OF_WAR_ON || FOG_DISTANCE_ON
		sum *= voidAlpha;
		#endif
		
		return sum;
	}
	
	// Fragment Shaders
	fixed4 fragBackFog (v2f i) : COLOR {
		fixed4 color = tex2D(_MainTex, i.uv);
		float depth01 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.depthUV)));
		float3 worldPos = getWorldPos(i, depth01);
		#if FOG_HAZE_ON
		if (depth01>=0.999) {		
			color = getSkyColor(color, worldPos);
		}
		#endif
		fixed4 sum = fogColor(worldPos, depth01);
		return color*(1.0-sum.a) + sum;
	}

	fixed4 fragOverlayFog (v2f i) : COLOR {
	    float depthTex = DecodeFloatRG (tex2D(_DepthTexture, i.depthUV).zw);
	    clip(depthTex - 0.00001);
    	float depth01 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.depthUV)));
    	clip(depth01 - depthTex);
  		fixed4 color = tex2D(_MainTex, i.uv);
		float3 worldPos = getWorldPos(i, depthTex);
		fixed4 sum = fogColor(worldPos, depthTex);
		return color*(1.0-sum.a) + sum;
	}
		
	fixed4 fragGetFog (v2f i) : COLOR {
    	float depth01  = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.depthUV)));
		float3 worldPos = getWorldPos(i, depth01);
		return fogColor(worldPos, depth01);
	}
	
	fixed4 fragApplyFog (v2f i) : COLOR {
  		fixed4 color = tex2D(_MainTex, i.uv);
		#if FOG_HAZE_ON
    	float depth01 = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.depthUV)));
		float3 worldPos = getWorldPos(i, depth01);
  		if (depth01>=0.999) {		
			color = getSkyColor(color, worldPos);
		}
		#endif
  		fixed4 sum = tex2D(_FogDownsampled, i.depthUV);
		return color*(1.0-sum.a) + sum;
	}

	ENDCG
	
	SubShader {
       	ZTest Always Cull Off ZWrite Off
       	Fog { Mode off }
		Pass {
	        CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragBackFog
			ENDCG
        }
		Pass {
	        CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragOverlayFog
			ENDCG
        }        
		Pass {
	        CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragGetFog
			ENDCG
        }        
		Pass {
	        CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragApplyFog
			ENDCG
        }        
	}
	FallBack Off
}