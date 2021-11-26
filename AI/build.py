from transformers import TrOCRProcessor, VisionEncoderDecoderModel
from
eng_processor = TrOCRProcessor.from_pretrained("microsoft/trocr-base-handwritten")
eng_model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-large-handwritten")
