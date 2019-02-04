// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved
//----------------------------------------------------------------------

Texture2D tx : register(t0);
SamplerState samLinear : register(s0);

float2 offset = float2(1 / 1920.0f, 1 / 1080.0f);

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};

float4 SimplerLighting(float4 mainColor)
{
    float3 clr = mainColor.rgb;

    float l = length(clr);

    clr /= l;
    if (l < 0.95f)
    {
        l = (int)(10.0f * l);
        //l -= l % 2;
        l /= 10.0f;
    }
    clr *= l;

    return float4(clr, 1.0f);
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
    //float2 offset = float2(1 / 1440.0f, 1 / 900.0f);
    //float leftUp = GetGreyscaledAndBlurredPixel(input.Tex + float2(-1, 1) * offset);
    //float leftMid = GetGreyscaledAndBlurredPixel(input.Tex + float2(-1, 0) * offset);
    //float leftDown = GetGreyscaledAndBlurredPixel(input.Tex + float2(-1, -1) * offset);

    //float midUp = GetGreyscaledAndBlurredPixel(input.Tex + float2(0, 1) * offset);
    //float midMid = GetGreyscaledAndBlurredPixel(input.Tex + float2(0, 0) * offset);
    //float midDown = GetGreyscaledAndBlurredPixel(input.Tex + float2(0, -1) * offset);

    //float rightUp = GetGreyscaledAndBlurredPixel(input.Tex + float2(1, 1) * offset);
    //float rightMid = GetGreyscaledAndBlurredPixel(input.Tex + float2(1, 0) * offset);
    //float rightDown = GetGreyscaledAndBlurredPixel(input.Tex + float2(1, -1) * offset);

    //float x = leftUp + 2 * midUp + rightUp - leftDown - 2 * midDown - rightDown;
    //float y = leftUp + 2 * leftMid + leftDown - rightUp - 2 * rightMid - rightDown;

    //float mg = sqrt(x * x + y * y);

    ////mg = clamp(mg, 0.0f, 1.0f);
    ////if (mg < 0.1f)
    ////    mg = 0.0f;
    ////else
    ////    mg = clamp(mg, 0.5f, 1.0f);


    //if (mg < 0.6f)
    //    mg = 0.0f;

    //float4 clr = tx.Sample(samLinear, input.Tex);

    //clr = SimplerLighting(clr);

    //clr.rgb *= (1.0f - mg);

    return float4(1.0f,0.0f,0.0f,1.0f);
}