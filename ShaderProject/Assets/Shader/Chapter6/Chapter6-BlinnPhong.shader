﻿Shader "Unlit/Chapter6-BlinnPhong"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
		_Specular("Specular",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8.0,256)) = 20
	}
		SubShader
	{

		Pass
	{
		Tags{ "LightMode" = "ForwardBase" }

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "Lighting.cginc"

		fixed4 _Diffuse;
	fixed4 _Specular;
	float _Gloss;


	struct a2v {
		float4 vertex :POSITION;
		float3 normal : NORMAL;
	};
	struct v2f {
		float4 pos : SV_POSITION;
		fixed3 worldNormal : TEXCOORD0;
		float3 worldPos : TEXCOORD1;
	};

	v2f vert(a2v v) {
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.worldNormal = mul(v.vertex, (float3x3)unity_WorldToObject);
		o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
		return o;
	}

	fixed4 frag(v2f i) : SV_Target{
		//环境光
		fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
	//转换法线
	float3 worldNormal = normalize(i.worldNormal);
	//得到光线方向
	float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
	//漫反射方程
	fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
	//高光

	fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
	fixed3 halfDir = normalize(viewDir + worldLightDir);

	fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(saturate(dot(worldNormal,halfDir)), _Gloss);
	return fixed4(ambient + diffuse + specular,1.0);
	}




		ENDCG
	}

	}
		Fallback "Specular"
}
