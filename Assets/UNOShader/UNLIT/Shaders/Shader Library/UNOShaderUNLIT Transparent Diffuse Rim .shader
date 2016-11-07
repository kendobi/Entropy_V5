// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//Version=1.2
Shader"UNOShader/_Library/UNLIT/UNOShaderUNLIT Transparent Diffuse Rim "
{
	Properties
	{
		_MainTex ("Diffuse Texture", 2D) = "white" {}
		_MainTexOpacity ("Diffuse Opacity", Range (0, 1)) = 1
		_RimColor ("Rim Color (A)Opacity", Color) = (1,1,1,1)
		_RimBias ("Rim Bias", Range (0, 5)) = 1
		_Transparency ("Transparency", Range(0,1)) = 1
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_MasksTex ("Masks", 2D) = "white" {}
	}
	SubShader
	{
		Tags
		{
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
		}
			Offset -1.0,0
			Blend SrcAlpha OneMinusSrcAlpha // --- not needed when doing cutout
		Pass
			{
			Name "ForwardBase"
			Tags
			{
				"RenderType" = "Transparent"
				"Queue" = "Transparent"
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile mathPixel_ON mathPixel_OFF
			#pragma multi_compile_fog
			fixed _Transparency;
			#if maskTex_ON
			sampler2D _MasksTex;
			float4 _MasksTex_ST;
			#endif

			float _MainTexOpacity;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4x4 _MatrixDiffuse;

			fixed4 _RimColor;
			fixed _RimBias;
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
				o.NdotV.y = ( 1-(clamp((dot(viewDir, v.normal) * _RimBias),0,1)) ) * _RimColor.a;
				#endif
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
				float fresnel = dot(viewDir, normalDirection);
				#endif
				#if maskTex_ON
			//__________________________________ Masks _____________________________________
				fixed4 T_Masks = tex2D(_MasksTex, i.uv.xy);
				#endif
			//__________________________________ Diffuse _____________________________________
				fixed4 T_Diffuse = tex2D(_MainTex, i.uv.xy);
				resultRGB = fixed4(T_Diffuse.rgb,(T_Diffuse.a * _MainTexOpacity));


			//__________________________________ Rim _____________________________________
				#if mathPixel_ON			
				fixed RimOpacity = (1-(clamp(fresnel * _RimBias ,0,1))) * _RimColor.a;
				#endif
				#if mathPixel_OFF
				fixed RimOpacity = i.NdotV.y;
				#endif
				#if maskTex_ON
				RimOpacity *= T_Masks.b;
				#endif
				resultRGB = lerp (resultRGB, _RimColor, RimOpacity);

			//__________________________________ Mask Occlussion _____________________________________
				#if maskTex_ON
				//--- Oclussion from alpha
				resultRGB.rgb = resultRGB.rgb * T_Masks.a;
				#endif

			//__________________________________ Fog  _____________________________________
				UNITY_APPLY_FOG(i.fogCoord, resultRGB);

			//__________________________________ Transparency master _____________________________________
			resultRGB.a *= _Transparency;
			//__________________________________ result Final  _____________________________________
				return resultRGB;
			}
			ENDCG
		}//-------------------------------Pass-------------------------------
	} //-------------------------------SubShader-------------------------------
	Fallback "UNOShader/_Library/Helpers/VertexUNLIT Transparent"
	CustomEditor "UNOShader_UNLIT"
}