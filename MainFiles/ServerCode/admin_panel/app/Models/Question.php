<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Question extends Model
{
    use HasFactory;

    protected $table = 'tbl_question';
    protected $guarded = array();

    public function category()
    {
        return $this->belongsTo(Category::class, 'category_id');
    }
    public function level()
    {
        return $this->belongsTo(Level::class, 'level_id');
    }
    public function contest()
    {
        return $this->belongsTo(Contest::class, 'contest_id');
    }

    protected $casts = [
        'id' => 'integer',
        'category_id' => 'integer',
        'contest_id' => 'integer',
        'level_id' => 'integer',
        'language_id' => 'integer',
        'question_level_master_id' => 'integer',
        'image' => 'string',
        'question' => 'string',
        'question_type' => 'integer',
        'option_a' => 'string',
        'option_b' => 'string',
        'option_c' => 'string',
        'option_d' => 'string',
        'answer' => 'string',
        'note' => 'string',
    ];
}
