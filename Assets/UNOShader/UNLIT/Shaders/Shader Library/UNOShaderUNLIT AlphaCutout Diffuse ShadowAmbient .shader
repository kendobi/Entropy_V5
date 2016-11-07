// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//Version=1.2
Shader"UNOShader/_Library/UNLIT/UNOShaderUNLIT AlphaCutout Diffuse ShadowAmbient "
{
	Properties
	{
		_MainTex ("Diffuse Texture", 2D) = "white" {}
		_MainTexOpacity ("Diffuse Opacity", Range (0, 1)) = 1
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_MasksTex ("Masks", 2D) = "white" {}
	}
	SubShader
	{
		Tags
		{
			"RenderType" = "TransparentCutout"
			"Queue" = "AlphaTest"
		}
			Offset -.5,0
		Pass
			{
			Name "ForwardBase"
			Tags
			{
				"RenderType" = "TransparentCutout"
				"Queue" = "AlphaTest"
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase
			#pragma multi_compile maskTex_ON maskTex_OFF
			#pragma multi_compile lmUV1_ON lmUV1_OFF
			#pragma multi_compile mathPixel_ON mathPixel_OFF
			#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			#if maskTex_ON
			sampler2D _MasksTex;
			float4 _MasksTex_ST;
			#endif

			float _MainTexOpacity;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4x4 _MatrixDiffuse;
			fixed _Cutoff;
			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
				float4 tangent : TANGENT;
				fixed2 texcoord : TEXCOORD0;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				fixed4 uv : TEXCOORD0;
				float4 posWorld : TEXCOORD1;//position of vertex in world;
				half3 normalDir : TEXCOORD2;//vertex Normal Direction in world space
				half4 NdotV : TEXCOORD4;
				LIGHTING_COORDS(6, 7)
				UNITY_FOG_COORDS(9)
			};
			v2f vert (customData v)
			{
				v2f o;
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.normalDir = UnityObjectToWorldNormal(v.normal);
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);//UNITY_MATRIX_MVP is a matrix that will convert a model's vertex position to the projection space
				o.uv = fixed4(0,0,0,0);
				o.uv.xy = TRANSFORM_TEX (v.texcoord, _MainTex); // this allows you to offset uvs and such	
				o.uv.xy = mul(_MatrixDiffuse, fixed4(o.uv.xy,0,1)); // this allows you to rotate uvs and such with script help
				o.NdotV = fixed4(0,0,0,0);
				#if mathPixel_OFF
				half3 viewDir =	normalize(ObjSpaceViewDir(v.vertex));
				#endif
				#if mathPixel_OFF
			//_____________________________ Vertex Directional light in forward base mode ______________________________________
				float3 normalDirection = normalize(float3( mul(float4(v.normal, 0.0), unity_WorldToObject).xyz ));
				float3 lightDirection = normalize(float3(_WorldSpaceLightPos0.xyz));
				o.NdotV.w = max(0.0, dot(normalDirection, lightDirection));
				#endif

				TRANSFER_VERTEX_TO_FRAGMENT(o) // This sets up the vertex attributes required for lighting and passes them through to the fragment shader.
			//_________________________________________ FOG  __________________________________________
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 resultRGB = fixed4(0,0,0,0);
			//__________________________________ Vectors _____________________________________
				#if mathPixel_ON
				float3 normalDirection = normalize(i.normalDir);
				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);//  float3 _WorldSpaceCameraPos.xyz built in gets camera Position
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);//float3 _WorldSpaceLightPos0 -> built in gets light Position
				#endif
				#if maskTex_ON
			//__________________________________ Masks _____________________________________
				fixed4 T_Masks = tex2D(_MasksTex, i.uv.xy);
				#endif
			//__________________________________ Diffuse _____________________________________
				fixed4 T_Diffuse = tex2D(_MainTex, i.uv.xy);
				resultRGB = fixed4(T_Diffuse.rgb,(T_Diffuse.a * _MainTexOpacity));

			//__________________________________Lighting _____________________________________
				fixed3 resultRGBnl = resultRGB;
				#if mathPixel_ON
				float NdotL = max(0.0,dot(normalDirection,lightDirection));
				#endif
				#if mathPixel_OFF
				half NdotL = i.NdotV.w;
				#endif
				#if maskTex_ON
				NdotL *= T_Masks.g;
				#endif
				float atten = LIGHT_ATTENUATION(i); // This gets the shadow and attenuation values combined.
			//__________________________________Shadows _____________________________________
				float3 diffReflection = NdotL * atten;
				#ifdef LIGHTMAP_ON
				resultRGB.rgb = lerp(resultRGB * UNITY_LIGHTMODEL_AMBIENT,resultRGB,atten);
				#endif
				#ifdef LIGHTMAP_OFF
				resultRGB.rgb = lerp(resultRGB * UNITY_LIGHTMODEL_AMBIENT,resultRGB,diffReflection);
				#endif

			//__________________________________ Mask Occlussion _____________________________________
				#if maskTex_ON
				//--- Oclussion from alpha
				resultRGB.rgb = resultRGB.rgb * T_Masks.a;
				#endif

			//__________________________________ Fog  _____________________________________
				UNITY_APPLY_FOG(i.fogCoord, resultRGB);

			//__________________________________ Alpha Cutout _____________________________________
			if(resultRGB.a < _Cutoff)discard;// use for cutout no need for render transparent or blend, this renders in opaque pass
			//__________________________________ result Final  _____________________________________
				return resultRGB;
			}
			ENDCG
		}//-------------------------------Pass-------------------------------
		UsePass "UNOShader/_Library/Helpers/Shadows AlphaCutout/SHADOWCAST"
		UsePass "UNOShader/_Library/Helpers/Shadows AlphaCutout/SHADOWCOLLECTOR"
	} //-------------------------------SubShader-------------------------------
	Fallback "UNOShader/_Library/Helpers/VertexUNLIT Transparent"
	CustomEditor "UNOShader_UNLIT"
}