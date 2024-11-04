<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Winners extends Model
{
    use HasFactory;

    protected $table = 'tbl_winners';
    protected $guarded = array();

    public function users()
    {
        return $this->belongsTo(Users::class, 'user_id');
    }

    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'contest_id' => 'integer',
        'rank' => 'integer',
        'point' => 'integer',
        'score' => 'string',
        'percentage' => 'string',
    ];
}
