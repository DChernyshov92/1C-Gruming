﻿&НаКлиенте
Процедура СформироватьФИО()
	Перем Фамилия, Имя, Отчество;
	Фамилия = Объект.Фамилия;
	Имя = Объект.Имя;
	Отчество = Объект.Отчество;
	Если Отчество = "" Тогда
		Объект.Наименование = Фамилия + " " + Имя;
	Иначе
		Объект.Наименование = Фамилия + " " + Имя + " " + Отчество; 
    КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда 
		СформироватьФИО();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	СформироватьФИО();
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	СформироватьФИО();
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	СформироватьФИО();
КонецПроцедуры

