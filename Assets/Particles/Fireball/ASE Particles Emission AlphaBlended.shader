// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SwiftApps/AmplifyShader/Particles/ASE Particle Emission Premultiplied"
{
	Properties
	{
		[NoScaleOffset]_MainTex("Albedo", 2D) = "white" {}
		[HDR]_Color("Albedo Color", Color) = (1,1,1,1)
		[NoScaleOffset]_EmissionMap("Emission", 2D) = "black" {}
		[HDR][Gamma]_EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True" "PreviewType"="Plane" }
	LOD 0

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGB
		ZWrite Off
		ZTest LEqual
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half4 _EmissionColor;
			uniform sampler2D _EmissionMap;
			uniform half4 _Color;
			uniform sampler2D _MainTex;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_EmissionMap3 = i.ase_texcoord1.xy;
				float2 uv_MainTex1 = i.ase_texcoord1.xy;
				half4 tex2DNode1 = tex2D( _MainTex, uv_MainTex1 );
				
				
				finalColor = ( half4( (( ( _EmissionColor * tex2D( _EmissionMap, uv_EmissionMap3 ) ) + ( _Color * tex2DNode1 ) )).rgb , 0.0 ) * tex2DNode1.a * i.ase_color );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18912
-1913;48;1920;971;983.774;420.8227;1.32919;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-248.6994,328.7243;Inherit;True;Property;_MainTex;Albedo;0;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;aeb95f677af3c474894bd9ea33b8eff3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-164.6667,108.3399;Half;False;Property;_Color;Albedo Color;1;1;[HDR];Create;False;0;0;0;False;0;False;1,1,1,1;1.498039,1.498039,1.498039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-343.7074,-102.5761;Inherit;True;Property;_EmissionMap;Emission;2;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;80103deb8da0745c88eca2aecc671819;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-264.7464,-307.3626;Half;False;Property;_EmissionColor;Emission Color;3;2;[HDR];[Gamma];Create;False;0;0;0;False;0;False;1,1,1,1;2,1.75,1.5,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;83.28407,160.033;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;86.34934,47.33186;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;276.49,264.7522;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;15;401.4458,260.2639;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;13;434.807,555.0514;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;617.7031,410.6696;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;10;770.8451,409.5736;Half;False;True;-1;2;ASEMaterialInspector;0;1;SwiftApps/AmplifyShader/Particles/ASE Particle Emission Premultiplied;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;3;1;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;2;False;-1;False;True;True;True;True;False;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;10;False;-1;True;4;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;IgnoreProjector=True;PreviewType=Plane;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;6;0;7;0
WireConnection;6;1;1;0
WireConnection;4;0;5;0
WireConnection;4;1;3;0
WireConnection;12;0;4;0
WireConnection;12;1;6;0
WireConnection;15;0;12;0
WireConnection;16;0;15;0
WireConnection;16;1;1;4
WireConnection;16;2;13;0
WireConnection;10;0;16;0
ASEEND*/
//CHKSM=3027CB547F0F0DED226ECFC3FE4D2C3F780C1FAD