using UnityEngine;
using System.Collections;

public class SkyboxController : MonoBehaviour {

	public Color colorStart = Color.blue;
	public Color colorEnd = Color.green;
	public float duration = 1.0F;

	// Use this for initialization
	void Start () {
	
	}
	

	void Update() {
		float lerp = transform.position.y / 15;
		RenderSettings.skybox.SetColor("_Tint", Color.Lerp(colorStart, colorEnd, lerp));

	}
}

