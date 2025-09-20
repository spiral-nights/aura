import { GoogleGenAI } from "@google/genai";

export function googleGenAI(apiKey) {
  return new GoogleGenAI({ vertexai: false, apiKey: apiKey });
}

export async function generateContent(googleGenAi, msgContent) {
  const response = await googleGenAi.models.generateContent(msgContent);
  return response.text;
}
