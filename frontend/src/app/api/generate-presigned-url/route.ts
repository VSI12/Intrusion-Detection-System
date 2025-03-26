import { NextResponse } from "next/server";
import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

const s3 = new S3Client({
  region: process.env.AWS_REGION!,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID!,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY!,
  },
});

export async function POST(req: Request) {
  try {
    const { file_name, file_type } = await req.json();

    const command = new PutObjectCommand({
      Bucket: process.env.AWS_S3_BUCKET_NAME!,
      Key: file_name,
      ContentType: file_type,
    });

    const url = await getSignedUrl(s3, command, { expiresIn: 60 * 5 });

    return NextResponse.json({ url });
  } catch (error) {
    return NextResponse.json({ error: "Error generating presigned URL" }, { status: 500 });
  }
}
