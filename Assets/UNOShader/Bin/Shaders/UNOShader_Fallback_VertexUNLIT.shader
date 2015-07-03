// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_LightmapInd', a built-in variable
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

Shader "UNOShader/_Library/Helpers/VertexUnlit" 
{
	Properties
	{		
		_Color ("Color (A)Opacity", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags
		{
		}
		Pass
			{
			Tags
			{
				"RenderType" = "Opaque"
				"Queue" = "Geometry"
				"LightMode" = "Vertex"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			//#pragma multi_compile_fwdbase			

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4x4 _MatrixDiffuse;

			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
				fixed2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				fixed4 vc : COLOR;
				fixed4 uv : TEXCOORD0;
			};
			v2f vert (customData v)
			{
				v2f o;
				o.pos = 	mul (UNITY_MATRIX_MVP, v.vertex);
				o.vc = v.color;
				o.uv = fixed4(0,0,0,0);
				o.uv.xy =		TRANSFORM_TEX (v.texcoord, _MainTex); // this allows you to offset uvs and such
				o.uv.xy = 	mul(_MatrixDiffuse, fixed4(o.uv.xy,0,1)); // this allows you to rotate uvs and such with script help
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);				
				fixed4 T_Diffuse = tex2D(_MainTex, i.uv.xy);
				result = _Color;
				fixed4 DiffResult = _Color * T_Diffuse;
				result = lerp(result,fixed4(DiffResult.rgb,1),T_Diffuse.a*_Color.a);
				result = fixed4(result.rgb * i.vc.rgb, result.a);
				result = fixed4(result.rgb,result.a * i.vc.a);
				return result;
			}
			ENDCG
		}//-------------------------------Pass-------------------------------
	
//	 //Lightmapped, encoded as RGBM
//		Pass {
//			Tags { "LightMode" = "VertexLMRGBM" }
//			
//			BindChannels {
//				Bind "Vertex", vertex
//				Bind "normal", normal
//				Bind "texcoord1", texcoord0 // lightmap uses 2nd uv
//				Bind "texcoord1", texcoord1 // unused
//				Bind "texcoord", texcoord2 // main uses 1st uv
//			}
//			
//			SetTexture [unity_Lightmap] {
//				matrix [unity_LightmapMatrix]
//				combine texture * texture alpha DOUBLE
//			}
//			SetTexture [unity_Lightmap] {
//				constantColor [_Color]
//				combine previous * constant
//			}
//			SetTexture [_MainTex] {
//				combine texture * previous QUAD, texture * primary
//			}
//		}
			Pass
			{
			Tags
			{
				"RenderType" = "Opaque"
				"Queue" = "Geometry"
				"LightMode" = "VertexLM"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			//#pragma multi_compile_fwdbase			

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4x4 _MatrixDiffuse;

			// sampler2D unity_Lightmap; //Far lightmap.
			// float4 unity_LightmapST; //Lightmap atlasing data.
			// sampler2D unity_LightmapInd; //Near lightmap (indirect lighting only).
			fixed _UNOShaderLightmapOpacity;
			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
				fixed2 texcoord : TEXCOORD0;
				fixed4 texcoord1 : TEXCOORD1;
				fixed4 color : COLOR;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				fixed4 vc : COLOR;
				fixed4 uv : TEXCOORD0;
				fixed2 uv2 : TEXCOORD1;
			};
			v2f vert (customData v)
			{
				v2f o;
				o.pos = 	mul (UNITY_MATRIX_MVP, v.vertex);
				o.vc = v.color;
				o.uv = fixed4(0,0,0,0);
				o.uv.xy =		TRANSFORM_TEX (v.texcoord, _MainTex); // this allows you to offset uvs and such
				o.uv.xy = 	mul(_MatrixDiffuse, fixed4(o.uv.xy,0,1)); // this allows you to rotate uvs and such with script help
				o.uv2 = 	v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw; //Unity matrix lightmap uvs
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);				
				fixed4 T_Diffuse = tex2D(_MainTex, i.uv.xy);
				fixed4 Lightmap = fixed4(DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv2)),1);
				result = _Color;
				fixed4 DiffResult = _Color * T_Diffuse;
				result = lerp(result,fixed4(DiffResult.rgb,1),T_Diffuse.a*_Color.a);
				result = fixed4(result.rgb * i.vc.rgb, result.a);
				result = lerp(result,result * Lightmap, _UNOShaderLightmapOpacity);
				result = fixed4(result.rgb,result.a * i.vc.a);
				return result;
			}
			ENDCG
		}//--- Pass ---
		Pass
			{
			Tags
			{
				"RenderType" = "Opaque"
				"Queue" = "Geometry"
				"LightMode" = "VertexLMRGBM"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			//#pragma multi_compile_fwdbase			

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4x4 _MatrixDiffuse;

			// sampler2D unity_Lightmap; //Far lightmap.
			// float4 unity_LightmapST; //Lightmap atlasing data.
			// sampler2D unity_LightmapInd; //Near lightmap (indirect lighting only).
			fixed _UNOShaderLightmapOpacity;
			struct customData
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
				fixed2 texcoord : TEXCOORD0;
				fixed4 texcoord1 : TEXCOORD1;
				fixed4 color : COLOR;
			};
			struct v2f // = vertex to fragment ( pass vertex data to pixel pass )
			{
				float4 pos : SV_POSITION;
				fixed4 vc : COLOR;
				fixed4 uv : TEXCOORD0;
				fixed2 uv2 : TEXCOORD1;
			};
			v2f vert (customData v)
			{
				v2f o;
				o.pos = 	mul (UNITY_MATRIX_MVP, v.vertex);
				o.vc = v.color;
				o.uv = fixed4(0,0,0,0);
				o.uv.xy =		TRANSFORM_TEX (v.texcoord, _MainTex); // this allows you to offset uvs and such
				o.uv.xy = 	mul(_MatrixDiffuse, fixed4(o.uv.xy,0,1)); // this allows you to rotate uvs and such with script help
				o.uv2 = 	v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw; //Unity matrix lightmap uvs
				return o;
			}

			fixed4 frag (v2f i) : COLOR  // i = in gets info from the out of the v2f vert
			{
				fixed4 result = fixed4(1,1,1,0);				
				fixed4 T_Diffuse = tex2D(_MainTex, i.uv.xy);
				fixed4 Lightmap = fixed4(DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv2)),1);
				result = _Color;
				fixed4 DiffResult = _Color * T_Diffuse;
				result = lerp(result,fixed4(DiffResult.rgb,1),T_Diffuse.a*_Color.a);
				result = fixed4(result.rgb * i.vc.rgb, result.a);
				result = lerp(result,result * Lightmap, _UNOShaderLightmapOpacity);
				result = fixed4(result.rgb,result.a * i.vc.a);
				return result;
			}
			ENDCG
		}//--- Pass ---
	} //-------------------------------SubShader-------------------------------

}
