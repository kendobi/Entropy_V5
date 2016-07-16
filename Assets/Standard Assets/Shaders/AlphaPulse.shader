// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:32719,y:32712,varname:node_4013,prsc:2|emission-3456-RGB,alpha-4553-OUT,voffset-1823-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:32409,y:32594,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:4553,x:32443,y:32958,ptovrint:False,ptlb:alpha,ptin:_alpha,varname:node_4553,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_TexCoord,id:3057,x:31099,y:32960,varname:node_3057,prsc:2,uv:0;n:type:ShaderForge.SFN_Panner,id:9856,x:31294,y:32971,varname:node_9856,prsc:2,spu:0,spv:-0.35|UVIN-3057-UVOUT;n:type:ShaderForge.SFN_ComponentMask,id:5321,x:31451,y:33014,varname:node_5321,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-9856-UVOUT;n:type:ShaderForge.SFN_Frac,id:8120,x:31615,y:33058,varname:node_8120,prsc:2|IN-5321-OUT;n:type:ShaderForge.SFN_Subtract,id:4452,x:31882,y:33098,varname:node_4452,prsc:2|A-8120-OUT,B-4912-OUT;n:type:ShaderForge.SFN_Vector1,id:4912,x:31686,y:33278,varname:node_4912,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Abs,id:2059,x:32073,y:33098,varname:node_2059,prsc:2|IN-4452-OUT;n:type:ShaderForge.SFN_Multiply,id:507,x:32222,y:33157,varname:node_507,prsc:2|A-2059-OUT,B-4288-OUT;n:type:ShaderForge.SFN_Vector1,id:4288,x:32029,y:33323,varname:node_4288,prsc:2,v1:2;n:type:ShaderForge.SFN_Power,id:6571,x:32373,y:33258,varname:node_6571,prsc:2|VAL-507-OUT,EXP-4101-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4101,x:32161,y:33404,ptovrint:False,ptlb:Bulge Shape,ptin:_BulgeShape,varname:node_4101,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:10;n:type:ShaderForge.SFN_Multiply,id:1823,x:32671,y:33366,varname:node_1823,prsc:2|A-6571-OUT,B-4362-OUT,C-3617-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4362,x:32416,y:33443,ptovrint:False,ptlb:Bulge Scale,ptin:_BulgeScale,varname:node_4362,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;n:type:ShaderForge.SFN_NormalVector,id:3617,x:32400,y:33642,prsc:2,pt:False;n:type:ShaderForge.SFN_Tex2d,id:3456,x:32054,y:32704,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_3456,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:e6c425fe3f067e340bac90e63e1f2f0b,ntxv:0,isnm:False;proporder:1304-4553-4101-4362-3456;pass:END;sub:END;*/

Shader "Shader Forge/AlphaPulse" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _alpha ("alpha", Float ) = 1
        _BulgeShape ("Bulge Shape", Float ) = 10
        _BulgeScale ("Bulge Scale", Float ) = 0.2
        _MainTex ("MainTex", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _alpha;
            uniform float _BulgeShape;
            uniform float _BulgeScale;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                UNITY_FOG_COORDS(2)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_3481 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_3481.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 emissive = _MainTex_var.rgb;
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,_alpha);
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
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _BulgeShape;
            uniform float _BulgeScale;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_7145 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_7145.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
