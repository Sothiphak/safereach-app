import { Body, Controller, Get, Post, UseGuards, Dependencies } from '@nestjs/common';

import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { buildValidationPipe } from '../../common/pipes/dto-validation.pipe';
import { AuthService } from './auth.service';
import { LoginDto, RegisterDto } from './auth.dto';

@Controller('auth')
@Dependencies(AuthService)
export class AuthController {
  constructor(authService) {
    this.authService = authService;
  }

  @Post('register')
  register(@Body(buildValidationPipe(RegisterDto)) payload) {
    return this.authService.register(payload);
  }

  @Post('login')
  login(@Body(buildValidationPipe(LoginDto)) payload) {
    return this.authService.login(payload);
  }

  @UseGuards(JwtAuthGuard)
  @Get('me')
  me(@CurrentUser() user) {
    return { user };
  }
}
