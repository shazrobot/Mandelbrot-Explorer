Shader "Explorer/Mandelbrot"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Area("Area", vector) = (0, 0, 4, 4)
			_Angle("Angle", range(-3.1415, 3.1415)) = 0
			_MaxIter("MaxIter", range(4, 10000)) = 255
			_Colour("Colour", range(0, 1)) = 0.5
			_Repeat("Repeat", float) = 1
			_ProceduralVariation("ProceduralVariation", range(1, 100)) = 20
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

			float4 _Area;
			float _Angle, _Colour, _Repeat;
			int _MaxIter, _ProceduralVariation;

            sampler2D _MainTex;

			float2 rotate(float2 p, float2 pivot, float a) {
				float s = sin(a);
				float c = cos(a);


				p -= pivot;
				p = float2(p.x*c - p.y*s, p.x*s+p.y*c);

				p += pivot;

				return p;
			}

            fixed4 frag (v2f i) : SV_Target
            {
                float2 c = _Area.xy + (i.uv - 0.5)*_Area.zw;
				c = rotate(c, _Area.xy, _Angle);

				float r = 2;
				float r2 = r* r;

				float2 z;
				float iter;
				for(iter = 0; iter < _MaxIter; iter++){
					z = float2(z.x*z.x - z.y*z.y, 2*z.x*z.y) + c;
					if(length(z) > r)break;
				}

				if (iter > _MaxIter-1) return 0;

				float dist = length(z);  //distance from origin
				float fracIter = (dist - r) / (r2 -r);
				fracIter = (log(dist) / log(r))-1;

				iter += fracIter;

				float m = sqrt(iter / _MaxIter);

				float4 colour = sin(float4(.3, .45, .65, 1)*m*_ProceduralVariation)*.5 + .5; // procedural colours
				//colour = tex2D(_MainTex, float2(m*_Repeat, _Colour)); //colours from texture
                return colour;
				//return m;
            }
            ENDCG
        }
    }
}
