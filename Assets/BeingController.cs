using UnityEngine;
using System.Collections;

public class BeingController : MonoBehaviour {

	public GameObject VFX;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void OnTriggerEnter(Collider other) {
		VFX.SetActive (true);
		Debug.Log ("TRIGGER WORKS");
	}
}
