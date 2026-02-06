using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.RenderGraphModule.Util;
using UnityEngine.Rendering.Universal;

public class ToneMappingRenderPass : ScriptableRenderPass
{
    private Material materoal_ = null;

    public ToneMappingRenderPass
        (Material posetEffectMaterial)
    {
        materoal_ = posetEffectMaterial;

    }

    public override void RecordRenderGraph
        (RenderGraph renderGraph, ContextContainer frameData)
    {

        if (materoal_ == null)
        {
            base.RecordRenderGraph(renderGraph, frameData);
            return;
        }

        UniversalResourceData resourceData = frameData.Get<UniversalResourceData>();

        if (resourceData.isActiveTargetBackBuffer)
        {
            base.RecordRenderGraph (renderGraph, frameData);

            return;
        }

        TextureHandle cameraTexture = resourceData.activeColorTexture;

        TextureDesc tempDesc = renderGraph.GetTextureDesc(cameraTexture);

        tempDesc.name = "_ToneMapping";

        tempDesc.depthBufferBits = 0;

        TextureHandle tempTexture = renderGraph.CreateTexture(tempDesc);

        RenderGraphUtils.BlitMaterialParameters blitMaterialParameters =
            new RenderGraphUtils.BlitMaterialParameters(cameraTexture,
            tempTexture, materoal_, 0);

        renderGraph.AddBlitPass(blitMaterialParameters,
            "BlitToneMapping");

        renderGraph.AddCopyPass(tempTexture, cameraTexture, "CopyToneMapping");


    }

}
