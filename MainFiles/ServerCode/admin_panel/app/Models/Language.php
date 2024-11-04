<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Language extends Model
{
    use HasFactory;

    protected $table = 'tbl_languages';
    protected $guarded = array();

    protected $casts = [
        'id' => 'integer',
        'language' => 'string',
        'lang_code' => 'string',
        'status' => 'integer',
    ];
}
