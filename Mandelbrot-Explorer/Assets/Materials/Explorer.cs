using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Explorer : MonoBehaviour
{
    private static float SMOOTH_VAL = 0.05f;
    public Material mat;
    public Vector2 position;
    public float scale, angle;

    private Vector2 smoothPos;
    private float smoothScale, smoothAngle;


    private void UpdateShader()
    {
        smoothPos = Vector2.Lerp(smoothPos, position, SMOOTH_VAL);
        smoothScale = Mathf.Lerp(smoothScale, scale, SMOOTH_VAL);
        smoothAngle = Mathf.Lerp(smoothAngle, angle, SMOOTH_VAL);

        float aspectRatio = (float)Screen.width / (float)Screen.height;

        float scaleX = smoothScale;
        float scaleY = smoothScale;

        if (aspectRatio > 1f)
            scaleY /= aspectRatio;
        else
            scaleX *= aspectRatio;

        mat.SetVector("_Area", new Vector4(smoothPos.x, smoothPos.y, scaleX, scaleY));
        mat.SetFloat("_Angle", smoothAngle);
    }

    private void HandleInputs()
    {
        if (Input.GetKey(KeyCode.KeypadPlus))
            scale *= .99f;
        if (Input.GetKey(KeyCode.KeypadMinus))
            scale *= 1.01f;

        if (Input.GetKey(KeyCode.Q))
            angle += .01f;
        if (Input.GetKey(KeyCode.E))
            angle -= .01f;

        Vector2 direction = new Vector2(.01f * scale, 0);
        float s = Mathf.Sin(angle);
        float c = Mathf.Cos(angle);
        direction = new Vector2(direction.x*c, direction.x*s);
        if (Input.GetKey(KeyCode.A))
            position -= direction;
        if (Input.GetKey(KeyCode.D))
            position += direction;

        direction = new Vector2(-direction.y, direction.x);

        if (Input.GetKey(KeyCode.W))
            position += direction;
        if (Input.GetKey(KeyCode.S))
            position -= direction;

        
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        HandleInputs();
        UpdateShader();
    }
}
