Texture2D tx : register(t0);
SamplerState samLinear : register(s0);

float2 offset = float2(1 / 1920.0f, 1 / 1080.0f);

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};

float4 PS(PS_INPUT input) : SV_Target
{
    float4 tmp = tx.Sample(samLinear, input.Tex);

    float x = (tmp.r * 0.3f + tmp.g * 0.59f + tmp.b * 0.11f);

    return float4(x, x, x, 1.0f);
}