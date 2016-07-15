// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:3,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:True,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:True,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1,x:33432,y:32396,varname:node_1,prsc:2|emission-9676-OUT,clip-1824-R,voffset-140-OUT;n:type:ShaderForge.SFN_Subtract,id:18,x:31984,y:32133,varname:node_18,prsc:2|A-22-OUT,B-19-OUT;n:type:ShaderForge.SFN_Vector1,id:19,x:31757,y:32160,varname:node_19,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Abs,id:21,x:32211,y:32197,varname:node_21,prsc:2|IN-18-OUT;n:type:ShaderForge.SFN_Frac,id:22,x:31757,y:31992,varname:node_22,prsc:2|IN-24-OUT;n:type:ShaderForge.SFN_Panner,id:23,x:31303,y:31852,varname:node_23,prsc:2,spu:0,spv:-0.35|UVIN-7085-UVOUT;n:type:ShaderForge.SFN_ComponentMask,id:24,x:31530,y:31923,varname:node_24,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-23-UVOUT;n:type:ShaderForge.SFN_Multiply,id:25,x:32438,y:32333,cmnt:Triangle Wave,varname:node_25,prsc:2|A-21-OUT,B-26-OUT;n:type:ShaderForge.SFN_Vector1,id:26,x:32211,y:32365,varname:node_26,prsc:2,v1:2;n:type:ShaderForge.SFN_Power,id:133,x:32665,y:32469,cmnt:Panning gradient,varname:node_133,prsc:2|VAL-25-OUT,EXP-8547-OUT;n:type:ShaderForge.SFN_NormalVector,id:139,x:32892,y:32957,prsc:2,pt:False;n:type:ShaderForge.SFN_Multiply,id:140,x:33119,y:32787,varname:node_140,prsc:2|A-133-OUT,B-142-OUT,C-139-OUT;n:type:ShaderForge.SFN_ValueProperty,id:142,x:32892,y:32789,ptovrint:False,ptlb:Bulge Scale,ptin:_BulgeScale,varname:_BulgeScale,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;n:type:ShaderForge.SFN_Tex2d,id:151,x:32466,y:31962,ptovrint:False,ptlb:Diffuse,ptin:_Diffuse,varname:_Diffuse,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False;n:type:ShaderForge.SFN_ValueProperty,id:8547,x:32438,y:32501,ptovrint:False,ptlb:Bulge Shape,ptin:_BulgeShape,varname:_BulgeShape,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:10;n:type:ShaderForge.SFN_Color,id:4485,x:32438,y:32146,ptovrint:False,ptlb:color2,ptin:_color2,varname:node_4485,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:0.9926471,c3:0.9926471,c4:1;n:type:ShaderForge.SFN_Slider,id:3032,x:32741,y:31596,ptovrint:False,ptlb:opacity,ptin:_opacity,varname:node_3032,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Multiply,id:4990,x:32710,y:32126,varname:node_4990,prsc:2|A-4485-RGB,B-151-RGB;n:type:ShaderForge.SFN_Tex2d,id:2547,x:32521,y:31588,ptovrint:False,ptlb:_MainTex,ptin:__MainTex,varname:_Diffuse_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False|UVIN-8255-OUT;n:type:ShaderForge.SFN_Color,id:2970,x:32442,y:31783,ptovrint:False,ptlb:color,ptin:_color,varname:_node_4485_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:0,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:897,x:32687,y:31793,varname:node_897,prsc:2|A-2970-RGB,B-2547-RGB;n:type:ShaderForge.SFN_Lerp,id:9676,x:33202,y:32401,varname:node_9676,prsc:2|A-4990-OUT,B-897-OUT,T-6914-OUT;n:type:ShaderForge.SFN_Multiply,id:6914,x:32970,y:31745,varname:node_6914,prsc:2|A-3032-OUT,B-2547-A;n:type:ShaderForge.SFN_TexCoord,id:6985,x:32096,y:31591,varname:node_6985,prsc:2,uv:0;n:type:ShaderForge.SFN_Add,id:8255,x:32356,y:31674,varname:node_8255,prsc:2|A-6985-UVOUT,B-8781-OUT;n:type:ShaderForge.SFN_Multiply,id:8781,x:32096,y:31774,varname:node_8781,prsc:2|A-8797-OUT,B-9355-T;n:type:ShaderForge.SFN_Time,id:9355,x:31893,y:31791,varname:node_9355,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:8797,x:31877,y:31713,ptovrint:False,ptlb:speed,ptin:_speed,varname:node_8797,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:5239,x:32923,y:32362,ptovrint:False,ptlb:alpha clip,ptin:_alphaclip,varname:node_5239,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Tex2d,id:1824,x:33202,y:32580,ptovrint:False,ptlb:Alpha,ptin:_Alpha,varname:node_1824,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_TexCoord,id:7085,x:31135,y:31852,varname:node_7085,prsc:2,uv:0;proporder:151-142-8547-4485-3032-2547-2970-8797-5239-1824;pass:END;sub:END;*/

Shader "Entropy/PulsingDecal" {
    Properties {
        _Diffuse ("Diffuse", 2D) = "white" {}
        _BulgeScale ("Bulge Scale", Float ) = 0.2
        _BulgeShape ("Bulge Shape", Float ) = 10
        _color2 ("color2", Color) = (1,0.9926471,0.9926471,1)
        _opacity ("opacity", Range(0, 1)) = 0
        __MainTex ("_MainTex", 2D) = "white" {}
        _color ("color", Color) = (1,0,1,1)
        _speed ("speed", Float ) = 1
        _alphaclip ("alpha clip", Float ) = 1
        _Alpha ("Alpha", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 ps3 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _BulgeScale;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float _BulgeShape;
            uniform float4 _color2;
            uniform float _opacity;
            uniform sampler2D __MainTex; uniform float4 __MainTex_ST;
            uniform float4 _color;
            uniform float _speed;
            uniform sampler2D _Alpha; uniform float4 _Alpha_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_2888 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_2888.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float4 _Alpha_var = tex2D(_Alpha,TRANSFORM_TEX(i.uv0, _Alpha));
                clip(_Alpha_var.r - 0.5);
////// Lighting:
////// Emissive:
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float4 node_9355 = _Time + _TimeEditor;
                float2 node_8255 = (i.uv0+(_speed*node_9355.g));
                float4 __MainTex_var = tex2D(__MainTex,TRANSFORM_TEX(node_8255, __MainTex));
                float3 emissive = lerp((_color2.rgb*_Diffuse_var.rgb),(_color.rgb*__MainTex_var.rgb),(_opacity*__MainTex_var.a));
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 ps3 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _BulgeScale;
            uniform float _BulgeShape;
            uniform sampler2D _Alpha; uniform float4 _Alpha_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
                float3 normalDir : TEXCOORD3;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_2220 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_2220.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float4 _Alpha_var = tex2D(_Alpha,TRANSFORM_TEX(i.uv0, _Alpha));
                clip(_Alpha_var.r - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
        Pass {
            Name "Meta"
            Tags {
                "LightMode"="Meta"
            }
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_META 1
            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #include "UnityMetaPass.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 ps3 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _BulgeScale;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float _BulgeShape;
            uniform float4 _color2;
            uniform float _opacity;
            uniform sampler2D __MainTex; uniform float4 __MainTex_ST;
            uniform float4 _color;
            uniform float _speed;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_4226 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_4226.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : SV_Target {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                UnityMetaInput o;
                UNITY_INITIALIZE_OUTPUT( UnityMetaInput, o );
                
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float4 node_9355 = _Time + _TimeEditor;
                float2 node_8255 = (i.uv0+(_speed*node_9355.g));
                float4 __MainTex_var = tex2D(__MainTex,TRANSFORM_TEX(node_8255, __MainTex));
                o.Emission = lerp((_color2.rgb*_Diffuse_var.rgb),(_color.rgb*__MainTex_var.rgb),(_opacity*__MainTex_var.a));
                
                float3 diffColor = float3(0,0,0);
                float specularMonochrome;
                float3 specColor;
                diffColor = DiffuseAndSpecularFromMetallic( diffColor, 0, specColor, specularMonochrome );
                o.Albedo = diffColor;
                
                return UnityMetaFragment( o );
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
