<?php

namespace App\Exports;

use App\Models\Daily_Quiz_Question;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class DailyQuizQuestionExport implements FromCollection, WithHeadings
{
    /**
     * @return \Illuminate\Support\Collection
     */
    public function collection()
    {
        return Daily_Quiz_Question::whereNull('id')->get();
    }
    public function headings(): array
    {
        return [
            ['question_type[ 1= normal, 2= true/false ]', 'question', 'option 1', 'option 2', 'option 3 {leave this blank cell if question_type is true/false}', 'option 4 {leave this blank cell if question_type is true/false}', 'answer', 'note', 'image {Please enter you image url}'],
            ['1', 'My question goes here?', 'option 1', 'option 2', 'option 3', 'option 4', '1', 'any note', ''],
            ['2', 'My second question here?', 'TRUE', 'FALSE', '', '', '1', 'any note', ''],
        ];
    }
}
