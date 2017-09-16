Shader "reaction-diffusion/StepShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_size("size",float) = 1024
		_time("time",float) = 0.0
		_distance("distance",int) = 1
		_f("f",Range (0.01, 0.09)) = 0.0
		_k("k",Range (0.03, 0.07)) = 0.04
		_du("du",float) = 0.2
		_dv("dv",float) = 0.1
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
			float _time;
			float _distance;
			float _f;
			float _k;
			float _du;
			float _dv;
			float _size;

			float fract(float x){
				return x-floor(x);
			}

			float rand(float2 co){
				return fract(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
			}

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{
				float2 uvOffset[4];  // サンプリングポイントのオフセット値  
				uvOffset[0]  = float2(0,_distance);
				uvOffset[1]  = float2(_distance,0);
				uvOffset[2]  = float2(0,-1*_distance);
				uvOffset[3]  = float2(-1*_distance,0);

				// 自身の情報を取得  
				float2 val = tex2D (_MainTex, i.uv).xy;  

				// 周囲８マスをサンプリング  
				float2 laplacian  = float2(0.0, 0.0);
				for( int j=0; j<4; ++j ) {  
					float2 duv = (i.uv.xy + (uvOffset[j] / _size));  
					laplacian  = laplacian + tex2D (_MainTex, duv).xy;  
				}

				laplacian  = laplacian - 4.0 * val;

				// パラメータを計算  
				float2 delta = float2(
					_du * laplacian.x - val.x*val.y*val.y + _f * (1.0-val.x),
					_dv * laplacian.y + val.x*val.y*val.y - (_k + _f) * val.y);


				float4 col = float4(val + delta * 1.0, 0, 0);


				//float2 clamped = clamp(val + delta * 1, 0.0, 1.0);
 
				//float4 col = float4(clamped, 0, 0);




				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);

				return col;
			}
			ENDCG
		}
	}
}
