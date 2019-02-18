Texture2D tx : register(t0);
SamplerState samLinear : register(s0);

cbuffer TransformProperties
{
    float zoom;
    float2 offset;
};

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};

float2 GetCenteredUVs(float2 uv)
{
    uv -= 0.5f;
    uv.y *= -1.0f;

    uv.x *= 16.0f / 9.0f;

    return uv;
}

float2 GetRevertedCenteredUVs(float2 uv)
{
    uv.x *= 9.0f / 16.0f;
    uv.y *= -1.0f;
    uv += 0.5f;

    return uv;
}

float4 PS(PS_INPUT input) : SV_Target
{
    float2 uv = GetCenteredUVs(input.Tex);

    uv /= 1.0f + zoom;

    float2 off = offset;
    off.y = -off.y;

    uv += off;

    uv = GetRevertedCenteredUVs(uv);

    return tx.Sample(samLinear, uv);
}