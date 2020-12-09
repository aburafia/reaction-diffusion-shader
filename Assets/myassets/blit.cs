using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class blit : MonoBehaviour {

    public List<Texture2D> texs;

    public RenderTexture mainRenderTexture;
    public RenderTexture ResultRenderTexture;
    public RenderTexture blendRenderTexture;

    public int Size = 1024;

    public Material StepMaterial;
    public Material calcMaterial;
    public Material blendMaterial;

    public bool DoBlend = false;

    public List<Vector2> presetParams = new List<Vector2>();

    int texsindex = 0;
    void attachTex()
    {
        int r = UnityEngine.Random.Range(0, texs.Count);

        //makeInitTextuer();
        Graphics.Blit(texs[r], mainRenderTexture);
    }

    int paramindex = 0;
    IEnumerator paramIndexSelecting()
    {
        while (true)
        {
            Debug.Log("パラメータかえました id=" + paramindex);

            attachTex();

            paramindex = UnityEngine.Random.Range(0, presetParams.Count);

            Vector2 v = presetParams[paramindex];

            StepMaterial.SetFloat("_f", v.x);
            StepMaterial.SetFloat("_k", v.y);

            //paramindex = paramindex == presetParams.Count - 1 ? 0 : paramindex + 1;


            yield return new WaitForSeconds(UnityEngine.Random.Range(5f, 20f));
        }
    }

    

    // Use this for initialization
    void Start () {

        presetParams.Add(new Vector2(0.0792f, 0.0609f));
        presetParams.Add(new Vector2(0.0832f, 0.0599f));
        presetParams.Add(new Vector2(0.084f, 0.0607f));
        presetParams.Add(new Vector2(0.0572f, 0.0609f));
        presetParams.Add(new Vector2(0.0712f, 0.0619f));




        GetComponent<Renderer>().material.SetTexture("_MainTex",  mainRenderTexture);

        Debug.Log("コピーした");


        StartCoroutine(paramIndexSelecting());

        StartCoroutine(UpdateTex());

    }


    IEnumerator UpdateTex()
    {

        Debug.Log("3");

        yield return 0;

        while (true) {

            if (DoBlend)
            {
                DoBlend = false;
                attachTex();

            }


            //ReplaceMaterial.SetFloat("_time", Time.deltaTime);

            for (int i = 0; i < 40; i++)
            {
                Graphics.Blit(mainRenderTexture, ResultRenderTexture, StepMaterial);
                Graphics.Blit(ResultRenderTexture, mainRenderTexture, StepMaterial);


               //GetComponent<Renderer>().material.SetTexture("_MainTex", mainRenderTexture);


            }

            Graphics.Blit(mainRenderTexture, blendRenderTexture, blendMaterial);


            yield return 0;



        }
    }
    
}
