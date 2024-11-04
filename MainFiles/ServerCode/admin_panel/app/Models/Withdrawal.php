<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Withdrawal extends Model
{
    use HasFactory;

    protected $table = 'tbl_withdrawal_request';
    protected $guarded = array();

    public function users()
    {
        return $this->belongsTo(Users::class, 'user_id');
    }

    protected $casts = [
        'id' => 'integer',
        'user_id' => 'integer',
        'point' => 'string',
        'total_amount' => 'string',
        'payment_type' => 'string',
        'payment_detail' => 'string',
        'status' => 'integer',
    ];
}
