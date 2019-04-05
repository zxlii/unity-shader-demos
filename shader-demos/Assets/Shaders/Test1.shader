Shader "Demo/Test1" {
	Properties{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_Tooniness("Tooniness", Range(0.1,20)) = 4
		_Outline ("Outline", Range(0,1)) = 0.4
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert
		struct Input{
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
		};
		sampler2D _MainTex;
		sampler2D _BumpMap;
		float _Tooniness;
		float _Outline;
		void surf(Input IN,inout SurfaceOutput o){
			half4 color = tex2D (_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal (tex2D(_BumpMap, IN.uv_BumpMap));

			half edge = saturate(dot(o.Normal, normalize(IN.viewDir)));
			edge = edge <_Outline?edge/8:1;

			o.Albedo = (floor(color.rgb * _Tooniness)/_Tooniness) * edge;
			o.Alpha = color.a;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
