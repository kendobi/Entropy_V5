using UnityEngine;
using System.Collections;

public class Playa : MonoBehaviour {

	public float speedH;
	public float speedV;

	private Animator anim;
	private Rigidbody rbody;

	private float inputH;
	private float inputV;

	public float speed = 3.0F;
	public float jumpSpeed = 8.0F;
	public float gravity = 20.0F;
	private Vector3 moveDirection = Vector3.zero;

	// Use this for initialization
	void Start () {
		anim = GetComponent<Animator> ();
		rbody = GetComponent<Rigidbody> ();	


	}
	
	// Update is called once per frame
	void Update () {

		CharacterController controller = GetComponent<CharacterController>();
		if (controller.isGrounded) {
			if (Input.GetMouseButtonDown (0)) {
				
				moveDirection = new Vector3 (1f, 0, 1f);
				moveDirection = transform.TransformDirection (moveDirection);
				moveDirection *= speed;
			}
			if (Input.GetButton("Jump"))
				moveDirection.y = jumpSpeed;

		}
		moveDirection.y -= gravity * Time.deltaTime;
		controller.Move(moveDirection * Time.deltaTime);

		/*inputH = Input.GetAxis ("Horizontal");
		inputV = Input.GetAxis ("Vertical");

		anim.SetFloat ("inputH", inputH);
		anim.SetFloat ("inputV", inputV);

		float moveX = inputH * speedH * Time.deltaTime;
		float moveZ = inputV * speedV * Time.deltaTime;

		rbody.velocity = new Vector3 (moveX,0f,moveZ);*/

	}
}
