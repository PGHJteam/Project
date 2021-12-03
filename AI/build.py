from transformers import TrOCRProcessor, VisionEncoderDecoderModel
from kobert_transformers import get_tokenizer
import pickle
eng_processor = TrOCRProcessor.from_pretrained("microsoft/trocr-base-handwritten")
eng_model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-handwritten")
ocr_model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-printed")

kobert = get_tokenizer()
with open('kobert_processor.pkl','wb') as f:
    pickle.dump(kobert,f)
