using UnityEngine;
using System.Collections;

public class ScaleOscillate : MonoBehaviour {

	public float amplitude;
	Vector3 scale;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		int i = 0;
		for (i = 0; i < 3; ++i) scale[i] = amplitude * Mathf.Sin(Time.time) + 1;
		transform.localScale = scale;
	}
}
