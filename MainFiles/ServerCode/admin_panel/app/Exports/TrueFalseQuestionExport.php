<?php

namespace App\Exports;

use App\Models\Video_Question;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class TrueFalseQuestionExport implements FromCollection, WithHeadings
{
    /**
     * @return \Illuminate\Support\Collection
     */
    public function collection()
    {
        return Video_Question::whereNull('id')->get();
    }
    public function headings(): array
    {
        return [
            ['category', 'question', 'answer[ 1= true, 2= false ]', 'note', 'image {Please enter you image url}'],
            ['1', 'My question goes here?', '1', 'any note', ''],
            ['1', 'My second question here?', '1', 'any note', ''],
        ];
    }
}
