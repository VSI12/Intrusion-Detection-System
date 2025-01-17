import ModelSelectionForm from "@/components/models";
import UploadDataset from "@/components/upload-dataset";


export default function Home() {
  return (
    <div className=" items-center justify-items-center  font-[family-name:var(--font-geist-sans)]">
      <UploadDataset />
      <ModelSelectionForm />
    </div>
  );
}
