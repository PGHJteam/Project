from transformers import TrOCRProcessor, VisionEncoderDecoderModel
from kobert_transformers import get_tokenizer
import pickle
eng_processor = TrOCRProcessor.from_pretrained("microsoft/trocr-base-handwritten")
eng_htr_model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-handwritten")
eng_ocr_model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-printed")

kobert = get_tokenizer()
with open('kobert_processor.pkl','wb') as f:
    pickle.dump(kobert,f)
with open('eng_processor.pkl','wb') as f:
  pickle.dump(eng_processor,f)
with open('eng_htr_model.pkl','wb') as f:
  pickle.dump(eng_htr_model,f)
with open('eng_ocr_model.pkl','wb') as f:
  pickle.dump(eng_ocr_model,f)

