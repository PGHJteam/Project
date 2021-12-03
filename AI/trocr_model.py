from transformers import TrOCRProcessor, VisionEncoderDecoderModel
import pickle
with open('eng_processor.pkl','rb') as f:
  eng_processor = pickle.load(f)
with open('eng_htr_model.pkl','rb') as f:
  eng_htr_model = pickle.load(f)
with open('eng_ocr_model.pkl','rb') as f:
  eng_ocr_model = pickle.load(f)
  

# eng_processor = TrOCRProcessor.from_pretrained("microsoft/trocr-base-handwritten")
# eng_model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-handwritten")

# pixel_values = processor(image, return_tensors="pt").pixel_values
# generated_ids = model.generate(pixel_values)
# generated_text = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
