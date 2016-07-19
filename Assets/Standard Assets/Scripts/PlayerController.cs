using UnityEngine;
using System.Collections;

public class PlayerController: MonoBehaviour
{
	private SphereCollider myCollider;


	void Start ()
	{
		myCollider = GetComponent<SphereCollider>();
	}


	void Update ()
	{
		if(Input.GetKeyUp(KeyCode.Space))
		{
			myCollider.enabled = !myCollider.enabled;
		}
	}
}