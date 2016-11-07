// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:500,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:32719,y:32712,varname:node_4013,prsc:2|emission-156-OUT,alpha-638-OUT,clip-8811-R,voffset-1823-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:31744,y:32197,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_TexCoord,id:3057,x:30288,y:33107,varname:node_3057,prsc:2,uv:0;n:type:ShaderForge.SFN_Panner,id:9856,x:30483,y:33118,varname:node_9856,prsc:2,spu:0,spv:-0.35|UVIN-3057-UVOUT;n:type:ShaderForge.SFN_ComponentMask,id:5321,x:30640,y:33161,varname:node_5321,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-9856-UVOUT;n:type:ShaderForge.SFN_Frac,id:8120,x:30804,y:33205,varname:node_8120,prsc:2|IN-5321-OUT;n:type:ShaderForge.SFN_Subtract,id:4452,x:31071,y:33245,varname:node_4452,prsc:2|A-8120-OUT,B-4912-OUT;n:type:ShaderForge.SFN_Vector1,id:4912,x:30875,y:33425,varname:node_4912,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Abs,id:2059,x:31367,y:33137,varname:node_2059,prsc:2|IN-4452-OUT;n:type:ShaderForge.SFN_Multiply,id:507,x:31516,y:33196,varname:node_507,prsc:2|A-2059-OUT,B-4288-OUT;n:type:ShaderForge.SFN_Vector1,id:4288,x:31323,y:33362,varname:node_4288,prsc:2,v1:2;n:type:ShaderForge.SFN_Power,id:6571,x:31667,y:33297,varname:node_6571,prsc:2|VAL-507-OUT,EXP-4101-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4101,x:31455,y:33443,ptovrint:False,ptlb:Bulge Shape,ptin:_BulgeShape,varname:node_4101,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:10;n:type:ShaderForge.SFN_Multiply,id:1823,x:32166,y:33206,varname:node_1823,prsc:2|A-6571-OUT,B-4362-OUT,C-3617-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4362,x:31710,y:33482,ptovrint:False,ptlb:Bulge Scale,ptin:_BulgeScale,varname:node_4362,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;n:type:ShaderForge.SFN_NormalVector,id:3617,x:31950,y:33438,prsc:2,pt:False;n:type:ShaderForge.SFN_Tex2d,id:3456,x:31786,y:32385,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_3456,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:e6c425fe3f067e340bac90e63e1f2f0b,ntxv:0,isnm:False|UVIN-4283-OUT;n:type:ShaderForge.SFN_Blend,id:717,x:32135,y:32526,varname:node_717,prsc:2,blmd:10,clmp:True|SRC-1304-RGB,DST-3456-RGB;n:type:ShaderForge.SFN_ValueProperty,id:130,x:31018,y:32353,ptovrint:False,ptlb:speed,ptin:_speed,varname:node_130,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:-0.2;n:type:ShaderForge.SFN_Time,id:5916,x:31018,y:32454,varname:node_5916,prsc:2;n:type:ShaderForge.SFN_Multiply,id:1918,x:31217,y:32394,varname:node_1918,prsc:2|A-130-OUT,B-5916-T;n:type:ShaderForge.SFN_TexCoord,id:7902,x:31225,y:32229,varname:node_7902,prsc:2,uv:0;n:type:ShaderForge.SFN_Add,id:4283,x:31527,y:32345,varname:node_4283,prsc:2|A-7902-UVOUT,B-1918-OUT;n:type:ShaderForge.SFN_Lerp,id:156,x:32431,y:32738,varname:node_156,prsc:2|A-717-OUT,B-3556-OUT,T-1890-OUT;n:type:ShaderForge.SFN_Tex2d,id:2349,x:31602,y:32820,ptovrint:False,ptlb:Diffuse,ptin:_Diffuse,varname:node_2349,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Blend,id:3556,x:31998,y:32793,varname:node_3556,prsc:2,blmd:10,clmp:True|SRC-1026-RGB,DST-2349-RGB;n:type:ShaderForge.SFN_Color,id:1026,x:31744,y:33012,ptovrint:False,ptlb:color2,ptin:_color2,varname:node_1026,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Slider,id:139,x:32082,y:32251,ptovrint:False,ptlb:opacity,ptin:_opacity,varname:node_139,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Multiply,id:1890,x:32322,y:32393,varname:node_1890,prsc:2|A-139-OUT,B-3456-A;n:type:ShaderForge.SFN_Slider,id:638,x:32126,y:32968,ptovrint:False,ptlb:alpha,ptin:_alpha,varname:node_638,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Tex2d,id:8811,x:32366,y:33074,ptovrint:False,ptlb:AlphaTex,ptin:_AlphaTex,varname:node_8811,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;proporder:1304-4101-4362-3456-130-2349-1026-139-638-8811;pass:END;sub:END;*/

Shader "Shader Forge/AlphaPulse" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _BulgeShape ("Bulge Shape", Float ) = 10
        _BulgeScale ("Bulge Scale", Float ) = 0.2
        _MainTex ("MainTex", 2D) = "white" {}
        _speed ("speed", Float ) = -0.2
        _Diffuse ("Diffuse", 2D) = "white" {}
        _color2 ("color2", Color) = (1,1,1,1)
        _opacity ("opacity", Range(0, 1)) = 0
        _alpha ("alpha", Range(0, 1)) = 1
        _AlphaTex ("AlphaTex", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent+500"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            
            
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
            uniform float4 _Color;
            uniform float _BulgeShape;
            uniform float _BulgeScale;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _speed;
            uniform sampler2D _Diffuse; uniform float4 _Diffuse_ST;
            uniform float4 _color2;
            uniform float _opacity;
            uniform float _alpha;
            uniform sampler2D _AlphaTex; uniform float4 _AlphaTex_ST;
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
                float4 node_7545 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_7545.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
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
                float4 _AlphaTex_var = tex2D(_AlphaTex,TRANSFORM_TEX(i.uv0, _AlphaTex));
                clip(_AlphaTex_var.r - 0.5);
////// Lighting:
////// Emissive:
                float4 node_5916 = _Time + _TimeEditor;
                float2 node_4283 = (i.uv0+(_speed*node_5916.g));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_4283, _MainTex));
                float4 _Diffuse_var = tex2D(_Diffuse,TRANSFORM_TEX(i.uv0, _Diffuse));
                float3 emissive = lerp(saturate(( _MainTex_var.rgb > 0.5 ? (1.0-(1.0-2.0*(_MainTex_var.rgb-0.5))*(1.0-_Color.rgb)) : (2.0*_MainTex_var.rgb*_Color.rgb) )),saturate(( _Diffuse_var.rgb > 0.5 ? (1.0-(1.0-2.0*(_Diffuse_var.rgb-0.5))*(1.0-_color2.rgb)) : (2.0*_Diffuse_var.rgb*_color2.rgb) )),(_opacity*_MainTex_var.a));
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
            uniform sampler2D _AlphaTex; uniform float4 _AlphaTex_ST;
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
                float4 node_2368 = _Time + _TimeEditor;
                v.vertex.xyz += (pow((abs((frac((o.uv0+node_2368.g*float2(0,-0.35)).g)-0.5))*2.0),_BulgeShape)*_BulgeScale*v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
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
                float4 _AlphaTex_var = tex2D(_AlphaTex,TRANSFORM_TEX(i.uv0, _AlphaTex));
                clip(_AlphaTex_var.r - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
