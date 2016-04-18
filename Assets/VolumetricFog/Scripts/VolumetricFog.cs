//------------------------------------------------------------------------------------------------------------------
// Volumetric Fog & Mist
// Copyright (c) Kronnect
//------------------------------------------------------------------------------------------------------------------
#define VOLUMETRIC_FOG_AND_MIST_PRESENT

using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
#if GAIA_PRESENT
using Gaia;
#endif


namespace VolumetricFogAndMist {

	public enum FOG_PRESET {
		Clear		= 0,
		Mist 		= 10,
		WindyMist 	= 11,
		LowClouds 	= 20,
		SeaClouds	= 21,
		GroundFog	= 30,
		FrostedGround = 31,
		FoggyLake   = 32,
		Fog			= 41,
		HeavyFog	= 42,
		SandStorm1	= 50,
		Smoke		= 51,
		ToxicSwamp  = 52,
		SandStorm2	= 53,
		WorldEdge   = 200,
		Custom 		= 1000
	}

	[ExecuteInEditMode]
	[RequireComponent(typeof(Camera))]
	public class VolumetricFog : MonoBehaviour {

		static VolumetricFog _fog;
		public static VolumetricFog instance { 
			get { 
				if (_fog==null) {
					foreach (Camera camera in Camera.allCameras) {
						_fog = camera.GetComponent<VolumetricFog>();
						if (_fog!=null) break;
					}
				}
				return _fog;
			} 
		}

		[HideInInspector]
		public bool isDirty;

		[SerializeField]
		FOG_PRESET _preset = FOG_PRESET.Mist;
		public FOG_PRESET preset {
			get { return _preset; }
			set { if (value!=_preset) { _preset = value; UpdatePreset(); isDirty = true; } }
		}

		[SerializeField]
		int _downsampling = 1;
		public int downsampling {
			get { return _downsampling; } 
			set { if (value!=_downsampling) { _downsampling = value; isDirty = true; } }
		}
	
		[SerializeField]
		bool _useFogVolumes = false;
		public bool useFogVolumes {
			get { return _useFogVolumes; }
			set { if (value!=_useFogVolumes) { _useFogVolumes = value; isDirty = true; } }
		}

		[SerializeField]
		bool _improveTransparency = false;
		public bool improveTransparency {
			get { return _improveTransparency; }
			set { if (value!=_improveTransparency) { 
					_improveTransparency = value; 
					if (_improveTransparency) renderOpaque = true;
					isDirty = true; } 
			}	
		}

		
		[SerializeField]
		bool _renderOpaque = true;
		public bool renderOpaque {
			get { return _renderOpaque; }
			set { if (value!=_renderOpaque) {
					_renderOpaque = value;
					if (!_renderOpaque) _improveTransparency = false;
					UpdateRenderComponents();
					isDirty = true; } 
			}
		}

		[SerializeField]
		GameObject _sun;
		public GameObject sun {
			get { return _sun; }
			set { if (value!=_sun) { _sun = value; UpdateSun(); } }
		}

		[SerializeField]
		float _density = 1.0f;
		public float density {
			get { return _density; } 
			set { if (value!=_density) { _density = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _noiseStrength = 0.8f;
		public float noiseStrength {
			get { return _noiseStrength; } 
			set { if (value!=_noiseStrength) { _noiseStrength = value; UpdateMaterialProperties(); UpdateTexture(); isDirty = true; } }
		}

		[SerializeField]
		float _distance = 0f;
		public float distance {
			get { return _distance; } 
			set { if (value!=_distance) { _distance = value; UpdateMaterialProperties(); isDirty = true; } }
		}
		
		[SerializeField]
		float _maxFogLength = 1000f;
		public float maxFogLength {
			get { return _maxFogLength; } 
			set { if (value!=_maxFogLength) { _maxFogLength = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _distanceFallOff = 0f;
		public float distanceFallOff {
			get { return _distanceFallOff; } 
			set { if (value!=_distanceFallOff) { _distanceFallOff = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _height = 4.0f;
		public float height {
			get { return _height; } 
			set { if (value!=_height) { _height = Mathf.Max(value, 0.00001f); UpdateMaterialProperties(); isDirty = true; } }
		}
		
		[SerializeField]
		float _baselineHeight = 0f;
		public float baselineHeight {
			get { return _baselineHeight; } 
			set { if (value!=_baselineHeight) { _baselineHeight = Mathf.Max(value, 0); UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		bool _baselineRelativeToCamera = false;
		public bool baselineRelativeToCamera {
			get { return _baselineRelativeToCamera; } 
			set { if (value!=_baselineRelativeToCamera) { _baselineRelativeToCamera = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _noiseScale = 1;
		public float noiseScale {
			get { return _noiseScale; } 
			set { if (value!=_noiseScale) { _noiseScale = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _stepping = 12.0f;
		public float stepping {
			get { return _stepping; } 
			set { if (value!=_stepping) { _stepping = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _steppingNear = 1f;
		public float steppingNear {
			get { return _steppingNear; } 
			set { if (value!=_steppingNear) { _steppingNear = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _alpha = 1.0f;
		public float alpha {
			get { return _alpha; } 
			set { if (value!=_alpha) { _alpha = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		Color _color = new Color (0.89f, 0.89f, 0.89f, 1);
		public Color color {
			get { return _color; } 
			set { if (value!=_color) { _color = value; UpdateMaterialProperties(); isDirty = true; } }
		}
		
		[SerializeField]
		Color _specularColor = new Color (1, 1, 0.8f, 1);
		public Color specularColor {
			get { return _specularColor; } 
			set { if (value!=_specularColor) { _specularColor = value; UpdateMaterialProperties(); isDirty = true; } }
		}
		
		[SerializeField]
		float _specularThreshold = 0.6f;
		public float specularThreshold {
			get { return _specularThreshold; } 
			set { if (value!=_specularThreshold) { _specularThreshold = value; UpdateTexture(); isDirty = true; } }
		}

		[SerializeField]
		float _specularIntensity = 0.2f;
		public float specularIntensity {
			get { return _specularIntensity; } 
			set { if (value!=_specularIntensity) { _specularIntensity = value; UpdateMaterialProperties(); UpdateTexture(); isDirty = true; } }
		}

		[SerializeField]
		Vector3 _lightDirection = new Vector3 (1, 0, -1);
		public Vector3 lightDirection {
			get { return _lightDirection; } 
			set { if (value!=_lightDirection) { _lightDirection = value; UpdateMaterialProperties(); UpdateTexture (); isDirty = true; } }
		}

		[SerializeField]
		float _lightIntensity = 0.2f;
		public float lightIntensity {
			get { return _lightIntensity; } 
			set { if (value!=_lightIntensity) { _lightIntensity = value; UpdateMaterialProperties(); isDirty = true; } }
		}
		
		[SerializeField]
		Color _lightColor = Color.white;
		public Color lightColor {
			get { return _lightColor; } 
			set { if (value!=_lightColor) { _lightColor = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _speed = 0.01f;
		public float speed {
			get { return _speed; } 
			set { if (value!=_speed) { _speed = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		Vector3 _windDirection = new Vector3 (-1, 0, 0);
		public Vector3 windDirection {
			get { return _windDirection; } 
			set { if (value!=_windDirection) { _windDirection = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _skyHaze = 50.0f;
		public float skyHaze {
			get { return _skyHaze; } 
			set { if (value!=_skyHaze) { _skyHaze = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _skySpeed = 0.3f;
		public float skySpeed {
			get { return _skySpeed; } 
			set { if (value!=_skySpeed) { _skySpeed = value; UpdateMaterialProperties(); isDirty = true; } }
		}
		
		[SerializeField]
		float _skyNoiseStrength = 0.1f;
		public float skyNoiseStrength {
			get { return _skyNoiseStrength; } 
			set { if (value!=_skyNoiseStrength) { _skyNoiseStrength = value; UpdateMaterialProperties(); isDirty = true; } }
		}
		
		[SerializeField]
		float _skyAlpha = 1.0f;
		public float skyAlpha {
			get { return _skyAlpha; } 
			set { if (value!=_skyAlpha) { _skyAlpha = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		GameObject _character;
		public GameObject character {
			get { return _character; }
			set { if (value!=_character) { 
					_character = value; 
					isDirty = true;
					if (_fogVoidRadius<20) {
						fogVoidRadius = 20;
					}
				}
			}
		}

		[SerializeField]
		float _fogVoidFallOff = 1.0f;
		public float fogVoidFallOff {
			get { return _fogVoidFallOff; } 
			set { if (value!=_fogVoidFallOff) { _fogVoidFallOff = value; UpdateMaterialProperties(); isDirty = true; } }
		}
		
		[SerializeField]
		float _fogVoidRadius = 0.0f;
		public float fogVoidRadius {
			get { return _fogVoidRadius; } 
			set { if (value!=_fogVoidRadius) { _fogVoidRadius = value; UpdateMaterialProperties(); isDirty = true; } }
		}
		
		[SerializeField]
		Vector3 _fogVoidPosition = Vector3.zero;
		public Vector3 fogVoidPosition {
			get { return _fogVoidPosition; } 
			set { if (value!=_fogVoidPosition) { _fogVoidPosition = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		float _fogVoidDepth = 0.0f;
		public float fogVoidDepth {
			get { return _fogVoidDepth; } 
			set { if (value!=_fogVoidDepth) { _fogVoidDepth = value; UpdateMaterialProperties(); isDirty = true; } }
		}
		
		[SerializeField]
		float _fogVoidHeight = 0.0f;
		public float fogVoidHeight {
			get { return _fogVoidHeight; } 
			set { if (value!=_fogVoidHeight) { _fogVoidHeight = value; UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		bool _fogOfWarEnabled;
		public bool fogOfWarEnabled {
			get { return _fogOfWarEnabled; }
			set { if (value!=_fogOfWarEnabled) { _fogOfWarEnabled = value; UpdateFogOfWarTexture(); UpdateMaterialProperties(); isDirty = true; } }
		}

		[SerializeField]
		Vector3 _fogOfWarCenter;
		public Vector3 fogOfWarCenter {
			get { return _fogOfWarCenter; }
			set { if (value!=_fogOfWarCenter) { _fogOfWarCenter = value; UpdateMaterialProperties(); isDirty = true; } }
		}
			
		[SerializeField]
		Vector3 _fogOfWarSize = new Vector3(1024,0,1024);
		public Vector3 fogOfWarSize {
			get { return _fogOfWarSize; }
			set { if (value!=_fogOfWarSize) { if (value.x>0 && value.z>0) { _fogOfWarSize = value; UpdateMaterialProperties(); isDirty = true; } } }
		}

		[SerializeField]
		int _fogOfWarTextureSize = 256;
		public int fogOfWarTextureSize {
			get { return _fogOfWarTextureSize; }
			set { if (value!=_fogOfWarTextureSize) { if (value>16) { _fogOfWarTextureSize = value; UpdateFogOfWarTexture(); UpdateMaterialProperties(); isDirty = true; } } }
		}
			
		Material fogMat;
		float initialFogAlpha, targetFogAlpha;
		float initialSkyHazeAlpha, targetSkyHazeAlpha;
		float transitionDuration;
		float transitionStartTime;
		float currentFogAlpha, currentSkyHazeAlpha;
		RenderTexture depthTexture, rtDest, reducedDestination;
		GameObject depthCamObj;
		Camera mainCamera;
		Light sunLight;
		Texture2D fogOfWarTexture;
		Color32[] fogOfWarColorBuffer;

		#region Game loop events

		void OnEnable () {
			targetFogAlpha = -1;
			targetSkyHazeAlpha = -1;
			currentFogAlpha = _alpha;
			currentSkyHazeAlpha = _skyAlpha;
			fogMat = Instantiate (Resources.Load<Material> ("Materials/VolumetricFog"));
			fogMat.hideFlags = HideFlags.DontSave;
			mainCamera = gameObject.GetComponent<Camera>();
			if (mainCamera.depthTextureMode == DepthTextureMode.None) {
				mainCamera.depthTextureMode = DepthTextureMode.Depth;
			}
			if (fogOfWarTexture==null) UpdateFogOfWarTexture();
			UpdatePreset();
		}

		void OnDisable() {
			if (depthCamObj==null) DestroyImmediate(depthCamObj);
		}

		void Start () {
			currentFogAlpha = _alpha;
			currentSkyHazeAlpha = _skyAlpha;
		}

		// Check possible alpha transition
		void Update () {
			// Check transitions
			if (targetFogAlpha >= 0 || targetSkyHazeAlpha>=0) {
				if (targetFogAlpha != currentFogAlpha || targetSkyHazeAlpha != currentSkyHazeAlpha) {
					if (transitionDuration > 0) {
						currentFogAlpha = Mathf.Lerp (initialFogAlpha, targetFogAlpha, (Time.time - transitionStartTime) / transitionDuration);
						currentSkyHazeAlpha = Mathf.Lerp (initialSkyHazeAlpha, targetSkyHazeAlpha, (Time.time - transitionStartTime) / transitionDuration);
					} else {
						currentFogAlpha = targetFogAlpha;
						currentSkyHazeAlpha = targetSkyHazeAlpha;
					}
					fogMat.SetFloat ("_FogAlpha", currentFogAlpha);
					fogMat.SetFloat ("_FogSkyAlpha", currentSkyHazeAlpha);
				}
			} else if (currentFogAlpha != _alpha || currentSkyHazeAlpha != _skyAlpha) {
				if (transitionDuration > 0) {
					currentFogAlpha = Mathf.Lerp (initialFogAlpha, _alpha, (Time.time - transitionStartTime) / transitionDuration);
					currentSkyHazeAlpha = Mathf.Lerp (initialSkyHazeAlpha, alpha, (Time.time - transitionStartTime) / transitionDuration);
				} else {
					currentFogAlpha = _alpha;
					currentSkyHazeAlpha = _skyAlpha;
				}
				fogMat.SetFloat ("_FogAlpha", currentFogAlpha);
				fogMat.SetFloat ("_FogSkyAlpha", currentSkyHazeAlpha);
			}

			if (_baselineRelativeToCamera) {
				UpdateMaterialHeight();
			}
			if (_character!=null) {
				_fogVoidPosition = _character.transform.position;
				UpdateMaterialVoidPosition();
			}
		}

		void UpdateRenderComponents() {
			if (_renderOpaque) {
				VolumetricFogPosT post = GetComponent<VolumetricFogPosT>();
				if (post!=null) DestroyImmediate(post);
				VolumetricFogPreT v = GetComponent<VolumetricFogPreT>();
				if (v==null) gameObject.AddComponent<VolumetricFogPreT>();
			} else {
				VolumetricFogPreT v = GetComponent<VolumetricFogPreT>();
				if (v!=null) DestroyImmediate(v);
				VolumetricFogPosT post = GetComponent<VolumetricFogPosT>();
				if (post==null) gameObject.AddComponent<VolumetricFogPosT>();
			}
		}

		// Postprocess the image
		internal void DoOnPreRender() {
			
			if (!enabled || !gameObject.activeSelf || !_improveTransparency) return;
			
			CleanUpTextures();
			
			Camera depthCam;
			if (depthCamObj==null) {
				depthCamObj = new GameObject("DepthCamera");
				depthCamObj.AddComponent<Camera>();
				depthCam = depthCamObj.GetComponent<Camera>();
				depthCam.enabled = false;
				depthCamObj.hideFlags = HideFlags.HideAndDontSave;
			} else {
				depthCam = depthCamObj.GetComponent<Camera>();
			}
			depthCam.CopyFrom(mainCamera);
			depthTexture = RenderTexture.GetTemporary(mainCamera.pixelWidth, mainCamera.pixelHeight, 16, RenderTextureFormat.ARGB32);
			depthCam.backgroundColor = new Color(0,0,0,0);
			depthCam.clearFlags = CameraClearFlags.SolidColor;;
			depthCam.targetTexture = depthTexture;
			depthCam.RenderWithShader(Shader.Find("VolumetricFogAndMist/CopyDepth"), "RenderType");
			fogMat.SetTexture("_DepthTexture", depthTexture);
		}
		
		internal void DoOnRenderImage (RenderTexture source, RenderTexture destination) {
			if (_density == 0 || !enabled) {
				Graphics.Blit (source, destination);
				return;
			}
			fogMat.SetMatrix ("_ClipToWorld", mainCamera.cameraToWorldMatrix * mainCamera.projectionMatrix.inverse);
			
			// Updates sun direction
			float sunLightIntensity = 1.0f;
			if (_sun!=null) {
				if (_sun.transform.forward != _lightDirection) {
					_lightDirection = _sun.transform.forward;
					UpdateTexture();
				}
				if (sunLight!=null) {
					if (sunLight.color     != _lightColor)     _lightColor = sunLight.color ;
					sunLightIntensity = sunLight.intensity;
				}
			}
			
			// Precompute light value and pass it to shader material
			float skyIntensity = (_lightIntensity + sunLightIntensity) * Mathf.Clamp01(1.0f-_lightDirection.y);
			fogMat.SetFloat ("_FogLightIntensity", skyIntensity);
			float fogIntensity = (_lightIntensity + sunLightIntensity) * Mathf.Clamp01(1.0f-_lightDirection.y * 2.0f);
			Vector3 liRGB = new Vector3(_lightColor.r, _lightColor.g, _lightColor.b) * fogIntensity;
			Color ambient = RenderSettings.ambientLight * RenderSettings.ambientIntensity;
			Vector3 ambientRGB = new Vector3(ambient.r, ambient.g, ambient.b);
			liRGB = Vector3.Lerp (ambientRGB, liRGB, fogIntensity);
			Color liColor = new Color(liRGB.x, liRGB.y, liRGB.z);
			fogMat.SetColor ("_FogLightColor", liColor);

			// Render fog before transparent objects are drawn and only having into account the depth of opaque objects
			if (_downsampling>1f) {
				reducedDestination = RenderTexture.GetTemporary (GetScaledSize(source.width, _downsampling), GetScaledSize(source.height, _downsampling), 0, RenderTextureFormat.ARGB32);
				Graphics.Blit (source, reducedDestination, fogMat, 2);
				fogMat.SetTexture("_FogDownsampled", reducedDestination);
				Graphics.Blit (source, destination, fogMat, 3);
				RenderTexture.ReleaseTemporary(reducedDestination);
			} else {
				Graphics.Blit (source, destination, fogMat, 0);
			}
			rtDest = destination;
		}
		
		internal void DoOnPostRender() {
			if (_density==0 || !enabled) return;
			Graphics.Blit (rtDest, fogMat, 1);
		}

		#endregion


		#region Core work

		public string GetCurrentPresetName() {
			return Enum.GetName(typeof(FOG_PRESET), _preset);
		}

		
		void UpdatePreset() {
			switch (_preset) {
			case FOG_PRESET.Clear:
				_density = 0;
				_fogOfWarEnabled = false;
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.Mist:
				_skySpeed = 0.3f;
				_skyHaze = 15;
				_skyNoiseStrength = 0.1f;
				_skyAlpha = 0.8f;
				_density = 0.07f;
				_noiseStrength = 0.6f;
				_noiseScale = 1;
				_distance = 0;
				_distanceFallOff = 0f;
				_height = 6;
				_stepping = 8;
				_steppingNear = 0;
				_alpha = 1;
				_color = new Color (0.89f, 0.89f, 0.89f, 1);
				_specularColor = new Color (1, 1, 0.8f, 1);
				_specularIntensity = 0.1f;
				_specularThreshold = 0.6f;
				_lightColor = Color.white;
				_lightIntensity = 0.12f;
				_speed = 0.01f;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.WindyMist:
				_skySpeed = 0.3f;
				_skyHaze = 25;
				_skyNoiseStrength = 0.1f;
				_skyAlpha = 0.85f;
				_density = 0.08f;
				_noiseStrength = 0.5f;
				_noiseScale = 1.15f;
				_distance = 0;
				_distanceFallOff = 0f;
				_height = 6.5f;
				_stepping = 10;
				_steppingNear = 0;
				_alpha = 1;
				_color = new Color (0.89f, 0.89f, 0.89f, 1);
				_specularColor = new Color (1, 1, 0.8f, 1);
				_specularIntensity = 0.1f;
				_specularThreshold = 0.6f;
				_lightColor = Color.white;
				_lightIntensity = 0;
				_speed = 0.15f;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.GroundFog:
				_skySpeed = 0.3f;
				_skyHaze = 0;
				_skyNoiseStrength = 0.1f;
				_skyAlpha = 0.85f;
				_density = 0.6f;
				_noiseStrength = 0.479f;
				_noiseScale = 1.15f;
				_distance = 5;
				_distanceFallOff = 1f;
				_height = 1.5f;
				_stepping = 8;
				_steppingNear = 0;
				_alpha = 0.95f;
				_color = new Color (0.89f, 0.89f, 0.89f, 1);
				_specularColor = new Color (1, 1, 0.8f, 1);
				_specularIntensity = 0.2f;
				_specularThreshold = 0.6f;
				_lightColor = Color.white;
				_lightIntensity = 0.2f;
				_speed = 0.01f;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.FrostedGround:
				_skySpeed = 0;
				_skyHaze = 0;
				_skyNoiseStrength = 0.729f;
				_skyAlpha = 0.55f;
				_density = 1;
				_noiseStrength = 0.164f;
				_noiseScale = 1.81f;
				_distance = 0;
				_distanceFallOff = 0;
				_height = 0.5f;
				_stepping = 20;
				_steppingNear = 50;
				_alpha = 0.97f;
				_color = new Color (0.546f, 0.648f, 0.710f, 1);
				_specularColor = new Color(0.792f, 0.792f, 0.792f, 1);
				_specularIntensity = 1;
				_specularThreshold = 0.866f;
				_lightColor = new Color(0.972f, 0.972f, 0.972f, 1);
				_lightIntensity = 0.743f;
				_speed = 0;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.FoggyLake:
				_skySpeed = 0.3f;
				_skyHaze = 40;
				_skyNoiseStrength = 0.574f;
				_skyAlpha = 0.827f;
				_density = 1;
				_noiseStrength = 0.03f;
				_noiseScale = 5.77f;
				_distance = 0;
				_distanceFallOff = 0;
				_height = 4;
				_stepping = 6;
				_steppingNear = 14.4f;
				_alpha = 1;
				_color = new Color (0, 0.960f, 1, 1);
				_specularColor = Color.white;
				_lightColor = Color.white;
				_specularIntensity = 0.861f;
				_specularThreshold = 0.907f;
				_lightIntensity = 0.126f;
				_speed = 0;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.LowClouds:
				_skySpeed = 0.3f;
				_skyHaze = 60;
				_skyNoiseStrength = 1f;
				_skyAlpha = 0.96f;
				_density = 1;
				_noiseStrength = 0.7f;
				_noiseScale = 1;
				_distance = 0;
				_distanceFallOff = 0;
				_height = 4f;
				_stepping = 12;
				_steppingNear = 0;
				_alpha = 0.98f;
				_color = new Color (0.89f, 0.89f, 0.89f, 1);
				_specularColor = new Color (1, 1, 0.8f, 1);
				_specularIntensity = 0.15f;
				_specularThreshold = 0.6f;
				_lightColor = Color.white;
				_lightIntensity = 0.15f;
				_speed = 0.008f;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.SeaClouds:
				_skySpeed = 0.3f;
				_skyHaze = 60;
				_skyNoiseStrength = 1f;
				_skyAlpha = 0.96f;
				_density = 1;
				_noiseStrength = 1;
				_noiseScale = 1.5f;
				_distance = 0;
				_distanceFallOff = 0;
				_height = 12.4f;
				_stepping = 6;
				_alpha = 0.98f;
				_color = new Color (0.89f, 0.89f, 0.89f, 1);
				_specularColor = new Color (1, 1, 0.8f, 1);
				_specularIntensity = 0.259f;
				_specularThreshold = 0.6f;
				_lightColor = Color.white;
				_lightIntensity = 0.15f;
				_speed = 0.008f;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.Fog:
				_skySpeed = 0.3f;
				_skyHaze = 144;
				_skyNoiseStrength = 0.7f;
				_skyAlpha = 0.9f;
				_density = 0.2f;
				_noiseStrength = 0.3f;
				_noiseScale = 1;
				_distance = 20;
				_distanceFallOff = 0.7f;
				_height = 8;
				_stepping = 8;
				_steppingNear = 0;
				_alpha = 0.97f;
				_color = new Color (0.89f, 0.89f, 0.89f, 1);
				_specularColor = new Color (1, 1, 0.8f, 1);
				_specularIntensity = 0;
				_specularThreshold = 0.6f;
				_lightColor = Color.white;
				_lightIntensity = 0;
				_speed = 0.05f;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.HeavyFog:
				_skySpeed = 0.05f;
				_skyHaze = 500;
				_skyNoiseStrength = 0.96f;
				_skyAlpha = 1;
				_density = 0.12f;
				_noiseStrength = 0.1f;
				_noiseScale = 1;
				_distance = 20;
				_distanceFallOff = 0.8f;
				_height = 18;
				_stepping = 6;
				_steppingNear = 0;
				_alpha = 1;
				_color = new Color (0.91f, 0.91f, 0.91f, 1);
				_specularColor = new Color (1, 1, 0.8f, 1);
				_specularIntensity = 0;
				_specularThreshold = 0.6f;
				_lightColor = Color.white;
				_lightIntensity = 0;
				_speed = 0.015f;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.SandStorm1:
				_skySpeed = 0.35f;
				_skyHaze = 388;
				_skyNoiseStrength = 0.847f;
				_skyAlpha = 1;
				_density = 0.487f;
				_noiseStrength = 0.758f;
				_noiseScale = 1.71f;
				_distance = 0;
				_distanceFallOff = 0;
				_height = 16;
				_stepping = 6;
				_steppingNear = 0;
				_alpha = 1;
				_color = new Color (0.505f, 0.505f, 0.505f, 1);
				_specularColor = new Color (1, 1, 0.8f, 1);
				_specularIntensity = 0;
				_specularThreshold = 0.6f;
				_lightColor = Color.white;
				_lightIntensity = 0;
				_speed = 0.3f;
				_windDirection = Vector3.right;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.Smoke:
				_skySpeed = 0.109f;
				_skyHaze = 10;
				_skyNoiseStrength = 0.119f;
				_skyAlpha = 1;
				_density = 1;
				_noiseStrength = 0.767f;
				_noiseScale = 1.6f;
				_distance = 0;
				_distanceFallOff = 0f;
				_height = 8;
				_stepping = 12;
				_steppingNear = 25;
				_alpha = 1;
				_color = new Color (0.125f, 0.125f, 0.125f, 1);
				_specularColor = new Color (1, 1, 1, 1);
				_specularIntensity = 0.575f;
				_specularThreshold = 0.6f;
				_lightColor = Color.white;
				_lightIntensity = 1;
				_speed = 0.075f;
				_windDirection = Vector3.right;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_baselineHeight += 8f;
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.ToxicSwamp:
				_skySpeed = 0.062f;
				_skyHaze = 22;
				_skyNoiseStrength = 0.694f;
				_skyAlpha = 1;
				_density = 1;
				_noiseStrength = 1;
				_noiseScale = 1;
				_distance = 0;
				_distanceFallOff = 0;
				_height = 2.5f;
				_stepping = 20;
				_steppingNear = 50;
				_alpha = 0.95f;
				_color = new Color (0.0238f, 0.175f, 0.109f, 1);
				_specularColor = new Color (0.593f, 0.625f, 0.207f, 1);
				_specularIntensity = 0.735f;
				_specularThreshold = 0.6f;
				_lightColor = new Color(0.730f, 0.746f, 0.511f,1);
				_lightIntensity = 0.492f;
				_speed = 0.0003f;
				_windDirection = Vector3.right;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;
			case FOG_PRESET.SandStorm2:
				_skySpeed = 0;
				_skyHaze = 0;
				_skyNoiseStrength = 0.729f;
				_skyAlpha = 0.55f;
				_density = 0.545f;
				_noiseStrength = 1;
				_noiseScale = 3;
				_distance = 0;
				_distanceFallOff = 0;
				_height = 12;
				_stepping = 5;
				_steppingNear = 19.6f;
				_alpha = 0.96f;
				_color = new Color (0.609f, 0.609f, 0.609f, 1);
				_specularColor = new Color (0.589f, 0.621f, 0.207f, 1);
				_specularIntensity = 0.505f;
				_specularThreshold = 0.6f;
				_lightColor = new Color(0.726f, 0.742f, 0.507f, 1);
				_lightIntensity = 0.581f;
				_speed = 0.168f;
				_windDirection = Vector3.right;
				_fogOfWarEnabled = false;
				_downsampling = 1;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				_fogVoidRadius = 0;
				break;			
			case FOG_PRESET.WorldEdge:
				_skySpeed = 0.3f;
				_skyHaze = 60;
				_skyNoiseStrength = 1f;
				_skyAlpha = 0.96f;
				_density = 1;
				_noiseStrength = 1;
				_noiseScale = 3f;
				_distance = 0;
				_distanceFallOff = 0;
				_height = 20f;
				_stepping = 6;
				_alpha = 0.98f;
				_color = new Color (0.89f, 0.89f, 0.89f, 1);
				_specularColor = new Color (1, 1, 0.8f, 1);
				_specularIntensity = 0.259f;
				_specularThreshold = 0.6f;
				_lightColor = Color.white;
				_lightIntensity = 0.15f;
				_speed = 0.03f;
				_fogOfWarEnabled = false;
				_downsampling = 2;
				_baselineRelativeToCamera = false;
				CheckWaterLevel();
				Terrain terrain = GetActiveTerrain();
				if (terrain!=null) {
					_fogVoidPosition = terrain.transform.position + terrain.terrainData.size * 0.5f;
					_fogVoidRadius = terrain.terrainData.size.x * 0.45f;
					_fogVoidHeight = terrain.terrainData.size.y;
					_fogVoidDepth = terrain.terrainData.size.z * 0.45f;
					_fogVoidFallOff = 6f;
					float terrainSize = terrain.terrainData.size.x;
					if (mainCamera.farClipPlane<terrainSize) mainCamera.farClipPlane = terrainSize;
					if (_maxFogLength<terrainSize * 0.6f) _maxFogLength = terrainSize * 0.6f;
				}
				break;
			}
			UpdateFogOfWarTexture();
			UpdateMaterialProperties();
			UpdateRenderComponents();
			UpdateTexture();
		}

		void CheckWaterLevel() {

			if (_baselineHeight>mainCamera.transform.position.y) _baselineHeight = 0;

			#if GAIA_PRESENT
			GaiaSceneInfo sceneInfo = GaiaSceneInfo.GetSceneInfo();
			_baselineHeight = sceneInfo.m_seaLevel;
			_renderOpaque = false;
			return;
			#else

			// Finds water
			GameObject water = GameObject.Find ("Water");
			if (water==null) {
				GameObject[] gos = GameObject.FindObjectsOfType<GameObject>();
				for (int k=0;k<gos.Length;k++) {
					if (gos[k]!=null && gos[k].layer == 4) {
						water = gos[k];
						break;
					}
				}
			}
			if (water!=null) {
				_renderOpaque = false;	// adds compatibility with water
				if (_baselineHeight<water.transform.position.y) _baselineHeight = water.transform.position.y;
			}
			#endif


		}


		void UpdateMaterialHeight() {
			float baseHeight = _baselineHeight;
			if (_baselineRelativeToCamera) baseHeight += mainCamera.transform.position.y - 1f;
			fogMat.SetFloat ("_FogHeight", _height);
			fogMat.SetFloat ("_FogBaseHeight", baseHeight);
			fogMat.SetFloat ("_FogSkyHaze", _skyHaze + baseHeight);
		}

		void UpdateMaterialVoidPosition() {
			fogMat.SetVector("_FogVoidPosition", _fogVoidPosition - _baselineHeight * Vector3.up);
		}
		
		void UpdateMaterialProperties() {
			fogMat.SetFloat ("_FogSkySpeed", _skySpeed);
			fogMat.SetFloat ("_FogSkyNoise", _skyNoiseStrength);
			fogMat.SetFloat ("_FogSkyAlpha", _skyAlpha);
			fogMat.SetVector ("_FogWindDir", _windDirection.normalized * _speed);
			fogMat.SetFloat ("_FogStepping", _stepping + 1);
			fogMat.SetFloat ("_FogSteppingNear", 1/(1+_steppingNear));
			fogMat.SetFloat ("_FogAlpha", _alpha);
			UpdateMaterialHeight();
			fogMat.SetFloat ("_FogScale", 0.01f / _noiseScale);
			fogMat.SetFloat ("_FogDensity", _density);
			fogMat.SetFloat ("_FogDistance", _distance);
			fogMat.SetFloat ("_MaxFogLength", _maxFogLength);
			fogMat.SetFloat ("_FogDistanceFallOff", _distanceFallOff);
			fogMat.SetColor ("_Color", _color);
			fogMat.SetFloat ("_FogSpecular", 1.0f + _specularIntensity);
			fogMat.SetColor ("_FogSpecularColor", _specularColor * (1.0f + _specularIntensity));
			fogMat.SetFloat ("_FogVoidFallOff", _fogVoidFallOff);
			fogMat.SetFloat ("_FogVoidRadius", 1.0f + _fogVoidRadius);
			fogMat.SetFloat ("_FogVoidHeight", 1.0f + _fogVoidHeight);
			fogMat.SetFloat ("_FogVoidDepth", 1.0f + _fogVoidDepth);
			UpdateMaterialVoidPosition();
			if (_fogOfWarEnabled) {
				fogMat.SetTexture("_FogOfWar", fogOfWarTexture);
				fogMat.SetVector("_FogOfWarCenter", _fogOfWarCenter);
				fogMat.SetVector("_FogOfWarSize", _fogOfWarSize);
				Vector3 ca = _fogOfWarCenter - 0.5f * _fogOfWarSize;
				fogMat.SetVector("_FogOfWarCenterAdjusted",  new Vector3(ca.x / _fogOfWarSize.x, 1f, ca.z / _fogOfWarSize.z));
			}

			// enable shader options
			List<string> shaderKeywords = new List<string>();
			if (_distance>0) shaderKeywords.Add ("FOG_DISTANCE_ON");
			if (_fogVoidRadius>0 && _fogVoidFallOff>0) {
				if (_fogVoidHeight>0 && _fogVoidDepth>0) {
					shaderKeywords.Add ("FOG_BOX_VOID_ON");
				} else {
					shaderKeywords.Add ("FOG_VOID_ON");
				}
			}
			if (_skyHaze>0 && _skyAlpha>0) {
				shaderKeywords.Add ("FOG_HAZE_ON");
			}
			if (_fogOfWarEnabled) {
				shaderKeywords.Add ("FOG_OF_WAR_ON");
			}
			fogMat.shaderKeywords = shaderKeywords.ToArray();
		}

		void UpdateTexture () {
			
			// red channel 	 = occlusion reference
			// green channel = fog height
			// blue channel  = noise value
			
			if (fogMat == null)
				return;
			Texture2D tex = (Texture2D)fogMat.GetTexture ("_NoiseTex");
			Color[] colors = tex.GetPixels ();
			
			float fogNoise = Mathf.Clamp (_noiseStrength, 0, 0.95f); 	// clamped to prevent flat fog on top
			
			// Precompute fog height into green channel
			for (int h=0; h<tex.height; h++) {
				int index = h * tex.width;
				for (int w=0; w<tex.width; w++,index++) {
					colors [index].g = (1 - colors [index].b * fogNoise);
				}
			}
			
			// Precompute occlusion into red channel
			Vector3 nlight = new Vector3(-_lightDirection.x, 0, -_lightDirection.z).normalized * 0.3f;
			nlight.y = _lightDirection.y > 0 ? Mathf.Clamp01(1.0f - _lightDirection.y) :  1.0f - Mathf.Clamp01(-_lightDirection.y);
			int nz = Mathf.FloorToInt(nlight.z * tex.width) * tex.width;
			int disp = (int)(nz + nlight.x * tex.width) + colors.Length;
			for (int h=0; h<tex.height; h++) {
				int index = h * tex.width;
				for (int w=0; w<tex.width; w++,index++) {
					int indexg = (index + disp) % colors.Length;
					colors [index].r = Mathf.Clamp01 ((colors [index].g - colors [indexg].g) * nlight.y / (1.0001f - _specularThreshold)) * _specularIntensity;
				}
			}
			tex.SetPixels (colors);
			tex.Apply ();
			
			fogMat.SetTexture ("_NoiseTex", tex);
		}

		void CleanUpTextures() {
			if (depthTexture) {
				RenderTexture.ReleaseTemporary(depthTexture);
				depthTexture = null;
			}
		}	

		void UpdateSun() {
			if (_sun!=null) {
				sunLight = _sun.GetComponent<Light>();
			}
		}
		
		int GetScaledSize(int size, float factor) {
			size = (int)(size / factor);
			size /= 4;
			if (size<1) size = 1;
			return size * 4;
		}

		#endregion


		#region Fog Volume

		public void SetTargetAlpha (float newFogAlpha, float newSkyHazeAlpha, float duration) {
			if (!_useFogVolumes) return;
			this.initialFogAlpha = currentFogAlpha;
			this.initialSkyHazeAlpha = currentSkyHazeAlpha;
			this.targetFogAlpha = newFogAlpha;
			this.targetSkyHazeAlpha = newSkyHazeAlpha;
			this.transitionDuration = duration;
			this.transitionStartTime = Time.time;
		}
		
		public void ClearTargetAlpha (float duration) {
			SetTargetAlpha(-1, -1, duration);
		}

		#endregion
	

		#region Fog Of War

		void UpdateFogOfWarTexture() {
			if (!_fogOfWarEnabled) return;
			int size = GetScaledSize(_fogOfWarTextureSize, 1.0f);
//			fogOfWarTexture = new Texture2D(size, size, TextureFormat.Alpha8, false);
			fogOfWarTexture = new Texture2D(size, size, TextureFormat.ARGB32, false);
			fogOfWarTexture.hideFlags = HideFlags.DontSave;
			fogOfWarTexture.filterMode = FilterMode.Bilinear;
			fogOfWarTexture.wrapMode = TextureWrapMode.Clamp;
			ResetFogOfWar();
		}

		/// <summary>
		/// Changes the alpha value of the fog of war at world position. It takes into account FogOfWarCenter and FogOfWarSize.
		/// Note that only x and z coordinates are used. Y (vertical) coordinate is ignored.
		/// </summary>
		/// <param name="worldPosition">in world space coordinates.</param>
		/// <param name="radius">radius of application in world units.</param>
		public void SetFogOfWarAlpha(Vector3 worldPosition, float radius, float fogNewAlpha) {
			if (fogOfWarTexture==null) return;

			float tx = (worldPosition.x - _fogOfWarCenter.x) / _fogOfWarSize.x + 0.5f;
			if (tx<0 || tx>1f) return;
			float tz = (worldPosition.z - _fogOfWarCenter.z) / _fogOfWarSize.z + 0.5f;
			if (tz<0 || tz>1f) return;

			int tw = fogOfWarTexture.width;
			int th = fogOfWarTexture.height;
			int px = (int)(tx * tw);
			int pz = (int)(tz * th);
			int colorBufferPos = pz * tw + px;
			byte newAlpha8 = (byte)(fogNewAlpha * 255);
			Color32 existingColor = fogOfWarColorBuffer[colorBufferPos];
			if (newAlpha8!=existingColor.a) { // just to avoid over setting the texture in an Update() loop
				float tr = radius / _fogOfWarSize.z;
				int delta = Mathf.FloorToInt(th * tr);
				for (int r=pz-delta;r<=pz+delta;r++) {
					if (r>0 && r<th-1) {
						for (int c=px-delta;c<=px+delta;c++) {
							if (c>0 && c<tw-1) {
								int distance = Mathf.FloorToInt( Mathf.Sqrt ( (pz-r)*(pz-r) + (px-c)*(px-c)));
								if (distance<=delta) {
									colorBufferPos = r * tw + c;
									Color32 colorBuffer = fogOfWarColorBuffer[colorBufferPos];
									colorBuffer.a = (byte)Mathf.Lerp(newAlpha8, colorBuffer.a, (float)distance/delta);
									fogOfWarColorBuffer[colorBufferPos] = colorBuffer;
									fogOfWarTexture.SetPixel(c, r, colorBuffer);
								}
							}
						}
					}
				}
				fogOfWarTexture.Apply();
			}
		}


		public void ResetFogOfWarAlpha(Vector3 worldPosition, float radius) {
			if (fogOfWarTexture==null) return;
			
			float tx = (worldPosition.x - _fogOfWarCenter.x) / _fogOfWarSize.x + 0.5f;
			if (tx<0 || tx>1f) return;
			float tz = (worldPosition.z - _fogOfWarCenter.z) / _fogOfWarSize.z + 0.5f;
			if (tz<0 || tz>1f) return;
			
			int tw = fogOfWarTexture.width;
			int th = fogOfWarTexture.height;
			int px = (int)(tx * tw);
			int pz = (int)(tz * th);
			int colorBufferPos = pz * tw + px;
			float tr = radius / _fogOfWarSize.z;
			int delta = Mathf.FloorToInt(th * tr);
			for (int r=pz-delta;r<=pz+delta;r++) {
				if (r>0 && r<th-1) {
					for (int c=px-delta;c<=px+delta;c++) {
						if (c>0 && c<tw-1) {
							int distance = Mathf.FloorToInt( Mathf.Sqrt ( (pz-r)*(pz-r) + (px-c)*(px-c)));
							if (distance<=delta) {
								colorBufferPos = r * tw + c;
								Color32 colorBuffer = fogOfWarColorBuffer[colorBufferPos];
								colorBuffer.a = 255;
								fogOfWarColorBuffer[colorBufferPos] = colorBuffer;
								fogOfWarTexture.SetPixel(c, r, colorBuffer);
							}
						}
					}
				}
				fogOfWarTexture.Apply();
			}
		}

		public void ResetFogOfWar() {
			if (fogOfWarTexture==null) return;
			int h = fogOfWarTexture.height;
			int w = fogOfWarTexture.width;
			int newLength = h * w;
			if (fogOfWarColorBuffer==null || fogOfWarColorBuffer.Length != newLength) {
				fogOfWarColorBuffer = new Color32[newLength];
			}
			Color32 opaque = new Color32(255,255,255,255);
			for (int k=0;k<newLength;k++) fogOfWarColorBuffer[k] = opaque;
			fogOfWarTexture.SetPixels32(fogOfWarColorBuffer);
			fogOfWarTexture.Apply();
			isDirty = true;
		}

		/// <summary>
		/// Get the currently active terrain - or any terrain
		/// </summary>
		/// <returns>A terrain if there is one</returns>
		public static Terrain GetActiveTerrain()
		{
			//Grab active terrain if we can
			Terrain terrain = Terrain.activeTerrain;
			if (terrain != null && terrain.isActiveAndEnabled)
			{
				return terrain;
			}
			
			//Then check rest of terrains
			for (int idx = 0; idx < Terrain.activeTerrains.Length; idx++)
			{
				terrain = Terrain.activeTerrains[idx];
				if (terrain != null && terrain.isActiveAndEnabled)
				{
					return terrain;
				}
			}
			return null;
		}


		#endregion



	}

}