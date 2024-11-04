<?php

namespace App\Exports;

use App\Models\Audio_Question;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class AudioQuestionExport implements FromCollection, WithHeadings
{
    /**
     * @return \Illuminate\Support\Collection
     */
    public function collection()
    {
        return Audio_Question::whereNull('id')->get();
    }
    public function headings(): array
    {
        return [
            ['category', 'audio_type{server_video/external_url}', 'audio {Please enter you audio url}', 'question_type[ 1= normal, 2= true/false ]', 'question', 'option 1', 'option 2', 'option 3 {leave this blank cell if question_type is true/false}', 'option 4 {leave this blank cell if question_type is true/false}', 'answer', 'note', 'image {Please enter you image url}'],
            ['1', 'server_video', '', '1', 'My question goes here?', 'option 1', 'option 2', 'option 3', 'option 4', '1', 'any note', ''],
            ['1', 'external_url', '', '2', 'My second question here?', 'TRUE', 'FALSE', '', '', '1', 'any note', ''],
        ];
    }
}
