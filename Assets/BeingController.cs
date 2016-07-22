using UnityEngine;
using System.Collections;

public class BeingController : MonoBehaviour {

	public GameObject VFX;

	Animator anim;

	// Use this for initialization
	void Start () {
		anim = GetComponent<Animator> ();
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void OnTriggerEnter(Collider other) {
		//if (Input.GetMouseButtonDown (0)) {
			anim.SetTrigger ("on");
			VFX.SetActive (true);
			//Debug.Log ("TRIGGER WORKS");
		//}
	}
}
