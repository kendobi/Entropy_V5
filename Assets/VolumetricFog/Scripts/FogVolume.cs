using UnityEngine;
using System.Collections;

namespace VolumetricFogAndMist {
	public class FogVolume : MonoBehaviour {

		[Tooltip("Target fog alpha when camera enters this fog volume")]
		[Range(0,1)]
		public float targetFogAlpha = 0.5f;
		[Tooltip("Target sky haze alpha when camera enters this fog volume")]
		[Range(0,1)]
		public float targetSkyHazeAlpha = 0.5f;
		[Tooltip("Set this to zero for changing fog alpha immediately upon enter/exit fog volume.")]
		public float transitionDuration = 3.0f;
		VolumetricFog fog;

		bool cameraInside;

		void Start () {
			fog = Camera.main.GetComponent<VolumetricFog>();
		}

		void OnTriggerEnter (Collider other) {
			if (cameraInside) return;
			// Check if other collider has the main camera attached
			if (other.gameObject.transform.GetComponentInChildren<Camera>() == Camera.main) {
				cameraInside = true;
				fog.SetTargetAlpha(targetFogAlpha, targetSkyHazeAlpha, transitionDuration);
			}
		}

		void OnTriggerExit(Collider other) {
			if (!cameraInside) return;
			if (other.gameObject.transform.GetComponentInChildren<Camera>() == Camera.main) {
				cameraInside = false;
				fog.ClearTargetAlpha(transitionDuration);
			}
		}

	}

}