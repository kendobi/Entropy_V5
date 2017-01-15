using UnityEngine;
using System.Collections;

public class TextController : MonoBehaviour {

	Animator animator;
	private bool pressed;
	private int numBreaths = 0;


	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator> ();
		pressed = false;
	
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown (0)) {
			pressed = true;
			numBreaths++;
		}
		if (Input.GetMouseButtonUp (0)) {
			pressed = false;
			if (numBreaths > 1) {
				numBreaths++;
			}


		}
		animator.SetBool ("isPressed", pressed);
		animator.SetInteger ("numBreaths", numBreaths);
	}
}
