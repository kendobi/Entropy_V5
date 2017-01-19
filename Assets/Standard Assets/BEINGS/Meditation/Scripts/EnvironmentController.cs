using UnityEngine;
using System.Collections;

public class EnvironmentController : MonoBehaviour {


	Animator animator;
	private bool pressed;


	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator> ();
		pressed = false;

	}

	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonUp (0)) {
			pressed = false;
		}
		if (Input.GetMouseButtonDown (0)) {
			pressed = true;
		}
		animator.SetBool ("isPressed", pressed);
		animator.SetInteger ("numBreaths", BreatheOutController.numBreaths);
	}
}
