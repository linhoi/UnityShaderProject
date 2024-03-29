﻿Shader "Chapter8/AlphaBlend"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_AlphaScale("Alpha Scale",Range(0,1)) = 1
	}
		SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }


		Pass
	{
		Tags{ "LightMode" = "ForwardBase" }
		ZWrite off //关闭深度检测
		//Cull off
		Blend SrcAlpha OneMinusSrcAlpha //设置混合模式
		CGPROGRAM
		
		#pragma vertex vert
		#pragma fragment frag
		#include "Lighting.cginc"

		struct a2v
	{
		float4 vertex : POSITION;
		float3 normal : NORMAL;
		float4 texcoord : TEXCOORD0;
	};

	struct v2f
	{
		float3 worldNormal : TEXCOORD0;
		float3 worldPos : TEXCOORD1;
		float2 uv : TEXCOORD2;
		float4 pos : SV_POSITION;
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;
	fixed4 _Color;
	fixed _AlphaScale;

	v2f vert(a2v v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
		o.worldNormal = UnityObjectToWorldNormal(v.normal);
		o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		fixed3 worldNormal = normalize(i.worldNormal);
		fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
		float4 texColor = tex2D(_MainTex, i.uv);
		//反射率
		fixed3 albedo = texColor.rgb*_Color.rgb;
		//环境
		fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
		fixed3 diffuse = _LightColor0.rgb*albedo*max(0, dot(worldNormal, worldLightDir));
		return fixed4(ambient + diffuse, texColor.a*_AlphaScale);

	}
		ENDCG
	}
	}
		FallBack"Transparent/VertexLit"
}
