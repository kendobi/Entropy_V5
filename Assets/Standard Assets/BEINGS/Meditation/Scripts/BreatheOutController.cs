using UnityEngine;
using System.Collections;

public class BreatheOutController : MonoBehaviour {

	Animator animator;
	private bool pressed = false;
	public static int numBreaths = 0;
	private float tapTime = 0.0f;
	private float timeSince = 0.0f;
	public float targetTime;

	public GameObject breatheOutObj;


	// Use this for initialization
	void Start () {
		animator = GetComponent<Animator> ();
	}

	// Update is called once per frame
	void Update () {

		if (Input.GetMouseButtonDown (0)) {
			pressed = true;
			tapTime = Time.time;
			}
		if (Input.GetMouseButtonUp (0)) {
			pressed = false;
			timeSince = Time.time - tapTime;

			if (timeSince >= targetTime) {
				numBreaths++;
				print ("full breath " + timeSince);
				}


		}

		animator.SetBool ("isPressed", pressed);
		animator.SetInteger ("numBreaths", numBreaths);
	}


	void Activate (int breaths){



	}
}
