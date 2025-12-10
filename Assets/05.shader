Shader "Unlit/05"
{
    Properties
    {
        _MainTex ("MainTexture", 2D) = "white" {}
        _SubTex("SubTexture", 2D) = "white" {}
        _MaskTex("MaskTexture",2d) = "black"{}
    }
    SubShader
    {
        
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;

               
            };

            sampler2D _MainTex;
            sampler2D _SubTex;
            sampler2D _MaskTex;
           
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                //fixed4 col = tex2D(_MainTex, i.uv);

                fixed4 main =tex2D(_MainTex,i.uv);
                fixed4 sub = tex2D (_SubTex,i.uv);
                fixed4 mask = tex2D(_MaskTex,i.uv);
                fixed4 col = mask.r * sub + (1 - mask.r)*main;
               
                // clip(0.5 - mask.r);


                return col;

            }

            ENDCG
        }
    }
}