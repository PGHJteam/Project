from pptx import Presentation
from pptx.util import Inches, Pt

from pghj_server.settings import TEMPLATE_DIR, MEDIA_DIR

# Change pixel into inch
def get_inch(x, y):
    r = x * 1280 / 96
    c = y * 720 / 96
    return Inches(r), Inches(c)
  

# Add slides
def add_slides(prs, items):
    # Add each slide
    for item in items:                             # one item per page
        slide_layout = prs.slide_layouts[6]        # Create slide_layout (6: BLANK)
        slide = prs.slides.add_slide(slide_layout) # Add a slide
        shapes = slide.shapes

        sentences = item['sentences']

        for sentence_block in sentences:
            sentence = sentence_block['sentence']
            left, top = get_inch(sentence_block['coordinate']['left'], sentence_block['coordinate']['top'])
            width, height = get_inch(sentence_block['size']['width'], sentence_block['size']['height'])
            font_type = sentence_block['font']['type']
            font_size = sentence_block['font']['size']            
        
            text_box = shapes.add_textbox(left, top, width, height) # Create text box
            text_frame = text_box.text_frame                        # Get text frame from the text box
            p = text_frame.add_paragraph()                          # Add paragraph into text frame
            p.text = sentence                                       # Write text

            if font_type == "bold": 
                p.font.bold = True

            if font_type == "italic": 
                p.font.italic = True

            p.font_size = Pt(font_size)      

    return prs


# Make presentation
def create_pptx(data, pptx_name):  
    items = data['items']
    template_id = data['template_id'] 
      
    # Create Presentation
    if template_id == "template00": # If user do not choose any template, open new presentation
        prs = Presentation()
    else:                           # Else, open the presentation with certain template
        prs = Presentation(TEMPLATE_DIR + str(template_id) + '.pptx')
    
    # Add slides
    prs = add_slides(prs, items)

    # Save pptx
    prs.save(MEDIA_DIR + pptx_name)
    return MEDIA_DIR
