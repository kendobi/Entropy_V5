//------------------------------------------------------------------------------------------------------------------
// Volumetric Fog & Mist
// Copyright (c) Kronnect Games
//------------------------------------------------------------------------------------------------------------------
using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;


namespace VolumetricFogAndMist {

	[ExecuteInEditMode]
	[RequireComponent(typeof(Camera), typeof(VolumetricFog))]
	public class VolumetricFogPosT : MonoBehaviour {
	
		VolumetricFog fog;

		void OnEnable() {
			fog = VolumetricFog.instance;
			if (fog==null) {
				fog = gameObject.AddComponent<VolumetricFog>();
			}
		}

		void OnRenderImage (RenderTexture source, RenderTexture destination) {
			if (fog!=null && fog.enabled) fog.DoOnRenderImage(source, destination);
		}


	}

}