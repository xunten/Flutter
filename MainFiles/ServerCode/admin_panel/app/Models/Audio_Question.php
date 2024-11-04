<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Audio_Question extends Model
{
    use HasFactory;

    protected $table = 'tbl_audio_question';
    protected $guarded = array();

    public function category()
    {
        return $this->belongsTo(Category::class, 'category_id');
    }
    public function level()
    {
        return $this->belongsTo(Level::class, 'level_id');
    }

    protected $casts = [
        'id' => 'integer',
        'category_id' => 'integer',
        'question' => 'string',
        'question_type' => 'integer',
        'option_a' => 'string',
        'option_b' => 'string',
        'option_c' => 'string',
        'option_d' => 'string',
        'audio_type' => 'string',
        'audio' => 'string',
        'answer' => 'string',
        'image' => 'string',
        'note' => 'string',
    ];
}
