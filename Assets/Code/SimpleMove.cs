using UnityEngine;

public class SimpleMove : MonoBehaviour
{
	[SerializeField] Vector3 moveSpeed;
	[SerializeField] float moveMultiply = 0.001f;

	private void LateUpdate()
	{
		transform.position += moveSpeed * moveMultiply;
	}
}
