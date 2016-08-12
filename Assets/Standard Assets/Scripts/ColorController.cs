using UnityEngine;
using System.Collections;

public class ColorController : MonoBehaviour {

	public Color colorStart = Color.blue;
	public Color colorEnd = Color.green;
	public float duration = 1.0F;
	public Renderer rend;

	// Use this for initialization
	void Start () {

	}


	void Update() {
		float lerp = transform.position.y / 15;
		rend.material.color = Color.Lerp(colorStart, colorEnd, lerp);

	}
}
