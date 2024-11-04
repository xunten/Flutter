<?php

namespace App\Imports;

use App\Models\TrueFalse_Question;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class TrueFalseQuestionImport implements ToModel, WithHeadingRow
{
    /**
     * @param array $row
     *
     * @return \Illuminate\Database\Eloquent\Model|null
     */

    public function model(array $row)
    {

        // Image
        $url = $row['image_please_enter_you_image_url'];
        $ext = pathinfo($row['image_please_enter_you_image_url']);
        // $source = file_get_contents($url);
        // dd($source);
        // dd(file_exists($url));
        if ($url && isset($ext['extension'])) {

            $image_name = rand(10, 100) . time() . '_qn' . '.' . $ext['extension'];
            $path = storage_path() . '/app/public/true_false_question/';

            file_put_contents($path . $image_name, file_get_contents($url));
            if ($image_name) {
                $question_img = $image_name;
            } else {
                $question_img = "";
            }
        } else {
            $question_img = "";
        }

        if ($row['answer_1_true_2_false'] == 1) {
            $answer = 1;
        } elseif ($row['answer_1_true_2_false'] == 2) {
            $answer = 2;
        } else {
            $answer = 1;
        }

        if ($row['note'] == null && !isset($row['note'])) {
            $row['note'] = "";
        }

        return new TrueFalse_Question([
            'category_id'   => $row['category'],
            'question'      => $row['question'],
            'option_a'      => "true",
            'option_b'      => "false",
            'answer'        => $answer,
            'note'          => $row['note'],
            'image'         => $question_img,
        ]);
    }
}
