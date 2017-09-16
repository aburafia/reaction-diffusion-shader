Shader "reaction-diffusion/calcShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_size("size",float) = 1024
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			const float COLOR_MIN = 0.2, COLOR_MAX = 0.4;
			//const float COLOR_MIN = 0.2, COLOR_MAX = 0.8;
			float _size;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			

			float4 frag (v2f i) : SV_Target
			{

				//float4 c = clamp(tex2D(_MainTex, i.uv),COLOR_MIN,COLOR_MAX );
				//float v = COLOR_MAX - tex2D(_MainTex, i.uv).y;

				//float v = abs(COLOR_MAX - tex2D(_MainTex, i.uv).y) / (COLOR_MAX - COLOR_MIN);
				//float v = COLOR_MAX - tex2D(_MainTex, i.uv).y / (COLOR_MAX - COLOR_MIN);


				float v = tex2D(_MainTex, i.uv).y / 0.2; 

				/*
				if (v > 0.4 ){
					v = 0.0;
				}

				if (v < 0.2 ){
					v = 1.0;
				}
				*/

				float4 col = float4(v, v, v, 1.0);
				//float4 col = float4(v, 1);
				return col;
				//return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}
