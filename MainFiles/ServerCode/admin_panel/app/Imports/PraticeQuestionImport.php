<?php

namespace App\Imports;

use App\Models\Pratice_Question;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class PraticeQuestionImport implements ToModel, WithHeadingRow
{
    /**
     * @param array $row
     *
     * @return \Illuminate\Database\Eloquent\Model|null
     */
    public function model(array $row)
    {
        try {
            $url = $row['image_please_enter_you_image_url'];
            $ext = pathinfo($row['image_please_enter_you_image_url']);

            // $source = file_get_contents($url);
            // dd($source);
            // dd(file_exists($url));

            if ($url && isset($ext['extension'])) {

                $image_name = rand(10, 100) . time() . '_qn' . '.' . $ext['extension'];
                $path = storage_path() . '/app/public/pratice_question/';

                file_put_contents($path . $image_name, file_get_contents($url));
                if ($image_name) {
                    $question_img = $image_name;
                } else {
                    $question_img = "";
                }
            } else {
                $question_img = "";
            }

            if ($row['question_type_1_normal_2_truefalse'] == 1) {
                $option_C = $row['option_3_leave_this_blank_cell_if_question_type_is_truefalse'];
                $option_D = $row['option_4_leave_this_blank_cell_if_question_type_is_truefalse'];
            } else {
                $option_C = "";
                $option_D = "";
            }

            if ($row['note'] == null && !isset($row['note'])) {
                $row['note'] = "";
            }

            return new Pratice_Question([
                'category_id'   => $row['category'],
                'level_id'      => $row['level'],
                'question'      => $row['question'],
                'question_type' => $row['question_type_1_normal_2_truefalse'],
                'option_a'      => $row['option_1'],
                'option_b'      => $row['option_2'],
                'option_c'      => $option_C,
                'option_d'      => $option_D,
                'answer'        => $row['answer'],
                'note'          => $row['note'],
                'image'         => $question_img,
                'question_level_master_id' => $row['classification_id'],
            ]);
        } catch (Exception $e) {
            return response()->json(array('status' => 400, 'errors' => $e->getMessage()));
        }
    }
}
