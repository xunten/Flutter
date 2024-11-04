<?php

namespace App\Exports;

use App\Models\Pratice_Question;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class PraticeQuestionExport implements FromCollection, WithHeadings
{
    /**
     * @return \Illuminate\Support\Collection
     */
    public function collection()
    {
        return Pratice_Question::whereNull('id')->get();
    }

    public function headings(): array
    {
        return [
            ['category', 'level', 'question_type{ 1= normal, 2= true/false }', 'question', 'option 1', 'option 2', 'option 3 {leave this blank cell if question_type is true/false}', 'option 4 {leave this blank cell if question_type is true/false}', 'answer', 'note', 'image {Please enter you image url}', 'classification_id'],
            ['1', '1', '1', 'My question goes here?', 'option 1', 'option 2', 'option 3', 'option 4', '1', 'any note', '', '1'],
            ['1', '1', '2', 'My second question here?', 'TRUE', 'FALSE', '', '', '1', 'any note', '', '1'],
        ];
    }
}
